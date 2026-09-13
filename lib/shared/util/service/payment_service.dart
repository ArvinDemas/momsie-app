import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/model/transaksi_model.dart';
import 'package:douce/shared/util/service/booking_slot_service.dart';
import 'package:douce/shared/util/service/zoom_link_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

/// Hasil dari createBookingTransaction
class BookingTransactionResult {
  final String txId;
  final String bookingId;
  BookingTransactionResult({required this.txId, required this.bookingId});
}

class PaymentService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  String get _collection => 'transactions';

  /// Buat transaksi biasa di Firestore, return ID
  Future<String> createTransaction({
    required String jenisLayanan,
    required String deskripsi,
    required int nominal,
    required String metodePembayaran,
  }) async {
    final user = _auth.currentUser;
    final String txId = 'TRX-${const Uuid().v4().substring(0, 8).toUpperCase()}';

    final transaksi = TransaksiModel(
      id: txId,
      userId: user?.uid ?? 'guest',
      namaUser: user?.displayName ?? user?.email ?? 'Pengguna',
      jenisLayanan: jenisLayanan,
      deskripsi: deskripsi,
      nominal: nominal,
      metodePembayaran: metodePembayaran,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    await _db.collection(_collection).doc(txId).set(transaksi.toMap());
    return txId;
  }

  /// Hitung split payment: 15% platform fee, 85% untuk doula
  /// Biaya admin Rp 2.000 tetap masuk ke Momsie
  static Map<String, int> calculateSplit(int hargaLayanan) {
    const platformFeePercent = 15;
    const doulaPercent = 85;
    final platformFee = (hargaLayanan * platformFeePercent ~/ 100);
    final doulaEarnings = (hargaLayanan * doulaPercent ~/ 100);
    return {'platformFee': platformFee, 'doulaEarnings': doulaEarnings};
  }

  /// Buat transaksi + booking record sekaligus di Firestore (Atomic Batch)
  /// Dengan split payment tracking
  Future<BookingTransactionResult> createBookingTransaction({
    required BookingModel booking,
    required String metodePembayaran,
  }) async {
    final user = _auth.currentUser;
    final String txId = 'TRX-${const Uuid().v4().substring(0, 8).toUpperCase()}';
    final String bookingId = 'BKG-${const Uuid().v4().substring(0, 8).toUpperCase()}';

    // Hitung split payment
    final split = PaymentService.calculateSplit(booking.hargaLayanan);

    final transaksi = TransaksiModel(
      id: txId,
      userId: user?.uid ?? 'guest',
      namaUser: user?.displayName ?? user?.email ?? 'Pengguna',
      jenisLayanan: 'doula',
      deskripsi: 'Booking ${booking.doulaName} – ${booking.layanan}',
      nominal: booking.totalBayar,
      metodePembayaran: metodePembayaran,
      status: 'pending',
      createdAt: DateTime.now(),
      platformFee: split['platformFee'] ?? 0,
      doulaEarnings: split['doulaEarnings'] ?? 0,
      bookingId: bookingId,
    );

    final finalBooking = BookingModel(
      id: bookingId,
      transactionId: txId,
      userId: user?.uid ?? 'guest',
      namaUser: user?.displayName ?? user?.email ?? 'Pengguna',
      doulaUid: booking.doulaUid,
      doulaName: booking.doulaName,
      doulaPhoto: booking.doulaPhoto,
      doulaJob: booking.doulaJob,
      tanggal: booking.tanggal,
      day: booking.day,
      jam: booking.jam,
      layanan: booking.layanan,
      alamat: booking.alamat,
      catatan: booking.catatan,
      hargaLayanan: booking.hargaLayanan,
      biayaAdmin: booking.biayaAdmin,
      totalBayar: booking.totalBayar,
      platformFee: split['platformFee']!,
      doulaEarnings: split['doulaEarnings']!,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    // Atomic slot reservation for scheduled bookings
    if (booking.doulaUid.isNotEmpty && booking.tanggal.isNotEmpty && booking.jam.isNotEmpty) {
      final reserved = await BookingSlotService().incrementBookedCount(
        doulaId: booking.doulaUid,
        tanggal: booking.tanggal,
        time: booking.jam,
      );
      if (!reserved) {
        throw Exception('Slot sudah penuh, silakan pilih jam lain');
      }
    }

    final batch = _db.batch();
    batch.set(_db.collection(_collection).doc(txId), transaksi.toMap());
    batch.set(_db.collection('bookings').doc(bookingId), finalBooking.toMap());

    await batch.commit();

    return BookingTransactionResult(txId: txId, bookingId: bookingId);
  }

  /// Auto-confirm booking setelah pembayaran berhasil (untuk layanan auto-confirm)
  Future<void> autoConfirmBooking(String bookingId, String layanan) async {
    final autoConfirmServices = [
      'chat_doula',
      'prenatal_yoga',
      'materi_online',
      'paket_bundling',
    ];

    if (!autoConfirmServices.contains(layanan)) return;

    final bookingRef = _db.collection('bookings').doc(bookingId);
    final bookingDoc = await bookingRef.get();
    if (!bookingDoc.exists) return;

    final booking = BookingModel.fromMap(bookingDoc.data()!, id: bookingId);
    if (booking.status != 'paid') return;

    await bookingRef.update({
      'status': 'confirmed',
      'confirmedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': 'system',
    });

    // Grant material access for on-demand services
    if (layanan == 'materi_online' || layanan == 'paket_bundling') {
      await _grantMaterialAccess(booking.userId, bookingId, layanan);
    }
  }

  /// Grant access to materials for on-demand services
  Future<void> _grantMaterialAccess(String userId, String bookingId, String layanan) async {
    try {
      final accessDoc = _db.collection('materi_access').doc('${userId}_$bookingId');
      await accessDoc.set({
        'userId': userId,
        'bookingId': bookingId,
        'layanan': layanan,
        'aksesSelamanya': true,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) debugPrint('Grant material access error: $e');
    }
  }

  /// Expire booking dengan merilis slot capacity
  Future<void> expireBookingWithCapacityRelease(String transactionId) async {
    // 1. Expire transaction
    await _db.collection('transactions').doc(transactionId).update({
      'status': 'expired',
      'expiredAt': FieldValue.serverTimestamp(),
    });

    // 2. Find and expire related booking
    final bookingQuery = await _db
        .collection('bookings')
        .where('transactionId', isEqualTo: transactionId)
        .get();

    for (var doc in bookingQuery.docs) {
      await doc.reference.update({
        'status': 'expired',
        'expiredAt': FieldValue.serverTimestamp(),
      });

      // Release slot capacity
      final data = doc.data();
      if (data['tanggal'] != null && data['jam'] != null && data['doulaUid'] != null) {
        final slotService = BookingSlotService();
        await slotService.decrementBookedCount(
          doulaId: data['doulaUid'],
          tanggal: data['tanggal'],
          time: data['jam'],
        );
      }
    }
  }

  /// Get zoom link for booking
  Future<String?> getZoomLinkForBooking(String bookingId) async {
    final zoomService = ZoomLinkService();
    return await zoomService.getZoomLink(bookingId);
  }

  /// Update status transaksi & sync ke booking terkait
  Future<void> updateStatus(String id, String status) async {
    final update = <String, dynamic>{'status': status};
    if (status == 'paid') {
      update['paidAt'] = FieldValue.serverTimestamp();
    }

    // 1. Update di collection 'transactions'
    try {
      final txDoc = await _db.collection(_collection).doc(id).get();
      if (txDoc.exists) {
        await txDoc.reference.update(update);
      } else {
        final query = await _db
            .collection(_collection)
            .where('bookingId', isEqualTo: id)
            .get();
        for (var doc in query.docs) {
          await doc.reference.update(update);
        }
      }
    } catch (e) {
      debugPrint('Transactions update error: $e');
    }

    // 2. Sync ke collection 'bookings'
    try {
      final bDoc = await _db.collection('bookings').doc(id).get();
      if (bDoc.exists) {
        await bDoc.reference.update(update);
      }
      final query = await _db
          .collection('bookings')
          .where('transactionId', isEqualTo: id)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update(update);
      }
    } catch (e) {
      debugPrint('Booking sync update error: $e');
    }
  }

  /// Expire (batalkan) transaksi dan booking terkait karena waktu habis
  Future<void> expireBooking(String transactionId) async {
    await _db.collection(_collection).doc(transactionId).update({
      'status': 'expired',
      'expiredAt': FieldValue.serverTimestamp(),
    });

    // Sync ke booking
    try {
      final query = await _db
          .collection('bookings')
          .where('transactionId', isEqualTo: transactionId)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'status': 'expired'});
      }
    } catch (e) {
      debugPrint('Expire booking error: $e');
    }
  }

  /// Update status booking (tanpa mengubah transaksi)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    final update = <String, dynamic>{'status': status};
    switch (status) {
      case 'paid':
        update['paidAt'] = FieldValue.serverTimestamp();
        break;
      case 'confirmed':
        update['confirmedAt'] = FieldValue.serverTimestamp();
        break;
      case 'completed':
        update['completedAt'] = FieldValue.serverTimestamp();
        break;
    }
    await _db.collection('bookings').doc(bookingId).update(update);
  }

  /// Confirm booking (admin action) — ubah status dari paid → confirmed
  Future<void> confirmBooking(String bookingId) async {
    await updateBookingStatus(bookingId, 'confirmed');
  }

  /// Cancel booking (admin action) — ubah status dari confirmed → cancelled
  Future<void> cancelBooking(String bookingId) async {
    await updateBookingStatus(bookingId, 'cancelled');
  }

  /// Upload bukti pembayaran ke Firebase Storage
  Future<String> uploadBukti(File imageFile, String transactionId) async {
    final ref = _storage.ref().child('payment_proofs/$transactionId.jpg');
    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();
    await _db.collection(_collection).doc(transactionId).update({
      'buktiPembayaran': url,
    });
    return url;
  }

  /// Stream semua transaksi untuk dashboard admin
  Stream<List<TransaksiModel>> streamAllTransaksi() {
    return _db
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => TransaksiModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

  /// Stream transaksi milik user tertentu
  Stream<List<TransaksiModel>> streamUserTransaksi(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => TransaksiModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

  /// Stream booking milik doula (mitra) tertentu
  Stream<List<BookingModel>> streamDoulaBookings(String doulaUid) {
    return _db
        .collection('bookings')
        .where('doulaUid', isEqualTo: doulaUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => BookingModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

  /// Stream booking milik user tertentu
  Stream<List<BookingModel>> streamUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => BookingModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

  /// Stream semua booking (untuk admin)
  Stream<List<BookingModel>> streamAllBookings() {
    return _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => BookingModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

  /// Stream semua transaksi dengan detail booking (gabungan)
  Stream<List<Map<String, dynamic>>> streamTransactionsWithBookings() {
    return _db.collection(_collection).orderBy('createdAt', descending: true).snapshots().map((snap) {
      return snap.docs.map((txDoc) {
        final tx = TransaksiModel.fromMap(txDoc.data(), id: txDoc.id);
        Map<String, dynamic>? bookingData;
        if (tx.bookingId != null && tx.bookingId!.isNotEmpty) {
          _db.collection('bookings').doc(tx.bookingId).get().then((bDoc) {
            if (bDoc.exists) bookingData = bDoc.data();
          });
        }
        return {'transaction': tx, 'booking': bookingData};
      }).toList();
    });
  }
}
