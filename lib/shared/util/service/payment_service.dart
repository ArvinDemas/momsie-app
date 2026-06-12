import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/transaksi_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PaymentService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  String get _collection => 'transactions';

  /// Buat transaksi baru di Firestore, return ID
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

    await _db
        .collection(_collection)
        .doc(txId)
        .set(transaksi.toMap());

    return txId;
  }

  /// Update status transaksi
  Future<void> updateStatus(String id, String status) async {
    final update = <String, dynamic>{'status': status};
    if (status == 'paid') {
      update['paidAt'] = DateTime.now().millisecondsSinceEpoch;
    }
    await _db.collection(_collection).doc(id).update(update);
  }

  /// Upload bukti pembayaran ke Firebase Storage
  Future<String> uploadBukti(File imageFile, String transactionId) async {
    final ref = _storage
        .ref()
        .child('payment_proofs/$transactionId.jpg');
    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();
    await _db.collection(_collection).doc(transactionId).update({
      'buktiPembayaran': url,
    });
    return url;
  }

  /// Simulasi verifikasi otomatis (delay 10 detik) → status: paid
  Future<void> simulateVerification(String transactionId) async {
    await Future.delayed(const Duration(seconds: 10));
    await updateStatus(transactionId, 'paid');
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
}
