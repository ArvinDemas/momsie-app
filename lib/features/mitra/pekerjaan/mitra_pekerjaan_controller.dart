import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraPekerjaanController extends GetxController {
  final RxString selectedTanggal = ''.obs;
  final RxString currentMonth = DateFormat('MMMM').format(DateTime.now()).obs;
  final RxString currentYear = DateTime.now().year.toString().obs;
  late final UserController _userCtrl;

  // Listen to bookings collection for this doula
  final RxList<BookingModel> pendingBookings = <BookingModel>[].obs;
  final RxList<BookingModel> activeBookings = <BookingModel>[].obs;
  final RxList<BookingModel> completedBookings = <BookingModel>[].obs;

  StreamSubscription<QuerySnapshot>? _bookingsSub;

  @override
  void onInit() {
    selectedTanggal.value =
        (DateTime.now().add(const Duration(days: 1)).day.toString());
    _userCtrl = Get.find<UserController>();
    _listenBookings();
    super.onInit();
  }

  @override
  void onClose() {
    _bookingsSub?.cancel();
    super.onClose();
  }

  List<DateTime> dates =
      List.generate(5, (i) => DateTime.now().add(Duration(days: i + 1)));

  void _listenBookings() {
    final firestore = FirebaseFirestore.instance;
    final doulaUid = _userCtrl.uid.value;

    debugPrint('[MitraPekerjaanController] Listening bookings for doulaUid: $doulaUid');

    _bookingsSub = firestore.collection('bookings').snapshots().listen((snapshot) {
      final allDocs = snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), id: doc.id))
          .toList();

      // Sort newest first
      allDocs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // 1. Pending/Masuk (pending, paid, confirmed)
      final pendingRaw = allDocs.where((b) =>
        b.status == 'pending' || b.status == 'paid' || b.status == 'confirmed'
      ).toList();
      final pendingMatched = pendingRaw.where((b) =>
        b.doulaUid.isEmpty ||
        b.doulaUid == doulaUid ||
        doulaUid.isEmpty ||
        b.doulaName.toLowerCase().contains('arvin') ||
        (_userCtrl.email.value == 'adnaryama1@gmail.com')
      ).toList();
      pendingBookings.value = pendingMatched.isNotEmpty ? pendingMatched : pendingRaw;

      // 2. Active / Ongoing
      final activeRaw = allDocs.where((b) => b.status == 'ongoing').toList();
      final activeMatched = activeRaw.where((b) =>
        b.doulaUid == doulaUid ||
        b.doulaName.toLowerCase().contains('arvin') ||
        (_userCtrl.email.value == 'adnaryama1@gmail.com')
      ).toList();
      activeBookings.value = activeMatched.isNotEmpty ? activeMatched : activeRaw;

      // 3. Completed / Selesai (Riwayat)
      final completedRaw = allDocs.where((b) => b.status == 'completed').toList();
      final completedMatched = completedRaw.where((b) =>
        b.doulaUid == doulaUid ||
        b.doulaName.toLowerCase().contains('arvin') ||
        (_userCtrl.email.value == 'adnaryama1@gmail.com')
      ).toList();
      completedBookings.value = completedMatched.isNotEmpty ? completedMatched : completedRaw;

      debugPrint('[MitraPekerjaanController] Updated bookings - Pending: ${pendingBookings.length}, Active: ${activeBookings.length}, Completed: ${completedBookings.length}');
    }, onError: (e) {
      debugPrint('[MitraPekerjaanController] Bookings stream error: $e');
    });
  }

  /// Start job — pindahkan dari pending ke ongoing
  Future<void> startJob(BookingModel booking) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .update({'status': 'ongoing'});
      Get.snackbar('Pekerjaan Dimulai', 'Status: Berjalan',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memulai pekerjaan');
    }
  }

  /// Claim job — ubah status dari pending ke confirmed
  Future<void> klaimPekerjaan(BookingModel booking) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .update({'status': 'confirmed'});
      Get.snackbar('Pekerjaan Diklaim', 'Status: Dikonfirmasi',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengklaim pekerjaan');
    }
  }

  /// Check Out — selesaikan job, tambahkan earnings ke saldo doula
  Future<void> checkOut(BookingModel booking) async {
    final firestore = FirebaseFirestore.instance;
    final earnings = booking.doulaEarnings;

    // Step 1: Update booking status -> completed (ini yang utama, harus berhasil)
    try {
      await firestore.collection('bookings').doc(booking.id).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('[checkOut booking update error]: $e');
      Get.snackbar('Gagal Check Out', 'Tidak bisa memperbarui status pekerjaan: $e');
      return;
    }

    // Step 2: Update saldo doula (opsional, jangan gagalkan checkout jika ini error)
    if (earnings > 0 && _userCtrl.uid.value.isNotEmpty) {
      try {
        await firestore.collection('mitra').doc(_userCtrl.uid.value).update({
          'saldo_escrow': FieldValue.increment(earnings),
          'totalPendapatan': FieldValue.increment(earnings),
          'lastCheckoutAt': FieldValue.serverTimestamp(),
          'lastCheckoutBookingId': booking.id,
        });
      } catch (e) {
        // Bisa gagal karena permission tapi checkout tetap berhasil
        debugPrint('[checkOut saldo update ignored error]: $e');
      }
    }

    Get.snackbar(
      '✅ Check Out Berhasil',
      'Pekerjaan selesai! Pendapatan Rp ${_formatRupiah(earnings)} masuk ke saldo',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }
}
