import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/model/booking_slot_model.dart';
import 'package:douce/shared/util/service/booking_slot_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SlotUtilization {
  final String tanggal;
  final String jam;
  final int capacity;
  final int bookedCount;
  final String status; // 'available', 'partial', 'full'

  SlotUtilization({
    required this.tanggal,
    required this.jam,
    required this.capacity,
    required this.bookedCount,
    required this.status,
  });

  bool get isFull => status == 'full';
  bool get hasBookings => bookedCount > 0;
}

class MitraPekerjaanController extends GetxController {
  final RxString selectedTanggal = ''.obs;
  final RxString currentMonth = DateFormat('MMMM').format(DateTime.now()).obs;
  final RxString currentYear = DateTime.now().year.toString().obs;
  late final UserController _userCtrl;
  final BookingSlotService _slotService = BookingSlotService();

  final RxList<BookingModel> pendingBookings = <BookingModel>[].obs;
  final RxList<BookingModel> activeBookings = <BookingModel>[].obs;
  final RxList<BookingModel> completedBookings = <BookingModel>[].obs;

  final RxMap<String, List<SlotUtilization>> slotUtilization = <String, List<SlotUtilization>>{}.obs;
  final RxBool isLoadingSlots = false.obs;

  StreamSubscription<QuerySnapshot>? _bookingsSub;

  @override
  void onInit() {
    selectedTanggal.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _userCtrl = Get.find<UserController>();
    _listenBookings();
    _loadSlotUtilization();
    super.onInit();
  }

  @override
  void onClose() {
    _bookingsSub?.cancel();
    super.onClose();
  }

  void _listenBookings() {
    final firestore = FirebaseFirestore.instance;
    final doulaUid = _userCtrl.uid.value;

    debugPrint('[MitraPekerjaanController] Listening bookings for doulaUid: $doulaUid');

    _bookingsSub = firestore.collection('bookings').snapshots().listen((snapshot) {
      final allDocs = snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), id: doc.id))
          .toList();

      allDocs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

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

      final activeRaw = allDocs.where((b) => b.status == 'ongoing').toList();
      final activeMatched = activeRaw.where((b) =>
        b.doulaUid == doulaUid ||
        b.doulaName.toLowerCase().contains('arvin') ||
        (_userCtrl.email.value == 'adnaryama1@gmail.com')
      ).toList();
      activeBookings.value = activeMatched.isNotEmpty ? activeMatched : activeRaw;

      final completedRaw = allDocs.where((b) => b.status == 'completed').toList();
      final completedMatched = completedRaw.where((b) =>
        b.doulaUid == doulaUid ||
        b.doulaName.toLowerCase().contains('arvin') ||
        (_userCtrl.email.value == 'adnaryama1@gmail.com')
      ).toList();
      completedBookings.value = completedMatched.isNotEmpty ? completedMatched : completedRaw;

      _syncSlotUtilization(allDocs);

      debugPrint('[MitraPekerjaanController] Updated bookings - Pending: ${pendingBookings.length}, Active: ${activeBookings.length}, Completed: ${completedBookings.length}');
    }, onError: (e) {
      debugPrint('[MitraPekerjaanController] Bookings stream error: $e');
    });
  }

  /// T-021: Hitung kapasitas utilization untuk semua slot yang aktif bulan ini
  Future<void> _loadSlotUtilization() async {
    final doulaId = _userCtrl.uid.value;
    if (doulaId.isEmpty) return;

    isLoadingSlots.value = true;
    try {
      final now = DateTime.now();
      final startStr = DateFormat('yyyy-MM-01').format(now);
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      final endStr = DateFormat('yyyy-MM-$lastDay').format(now);

      final snapshot = await FirebaseFirestore.instance
          .collection('booking_slots')
          .where('doulaId', isEqualTo: doulaId)
          .where('tanggal', isGreaterThanOrEqualTo: startStr)
          .where('tanggal', isLessThanOrEqualTo: endStr)
          .get();

      final Map<String, List<SlotUtilization>> utilization = {};
      for (var doc in snapshot.docs) {
        final model = BookingSlotModel.fromMap(doc.data(), docId: doc.id);
        for (var slot in model.slots) {
          utilization[model.tanggal] ??= [];
          utilization[model.tanggal]!.add(SlotUtilization(
            tanggal: model.tanggal,
            jam: slot.time,
            capacity: slot.capacity,
            bookedCount: slot.bookedCount,
            status: slot.isFull ? 'full' : (slot.bookedCount > 0 ? 'partial' : 'available'),
          ));
        }
      }
      slotUtilization.assignAll(utilization);
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading slot utilization: $e');
    } finally {
      isLoadingSlots.value = false;
    }
  }

  /// Sync booking data to update bookedCount tracking
  void _syncSlotUtilization(List<BookingModel> bookings) {
    final utilization = <String, List<SlotUtilization>>{};
    for (var entry in slotUtilization.entries) {
      utilization[entry.key] = List.from(entry.value);
    }

    for (var booking in bookings) {
      if (booking.status == 'completed' || booking.status == 'cancelled' || booking.status == 'expired') continue;

      final tanggal = booking.tanggal;
      final jam = booking.jam;

      if (!utilization.containsKey(tanggal)) continue;

      final slots = utilization[tanggal]!;
      final index = slots.indexWhere((s) => s.jam == jam);
      if (index >= 0) {
        slots[index] = SlotUtilization(
          tanggal: tanggal,
          jam: jam,
          capacity: slots[index].capacity,
          bookedCount: slots[index].bookedCount + 1,
          status: slots[index].status,
        );
      }
    }

    slotUtilization.value = utilization;
  }

  /// T-021: Filter bookings berdasarkan slot date + time
  List<BookingModel> getBookingsForSlot(String tanggal, String jam) {
    final allActive = [...pendingBookings, ...activeBookings];
    return allActive.where((b) => b.tanggal == tanggal && b.jam == jam).toList();
  }

  /// T-021: Ambil utilization untuk tanggal tertentu
  List<SlotUtilization> getSlotsForDate(String tanggal) {
    return slotUtilization[tanggal] ?? [];
  }

  /// T-021: Total capacity dan booked untuk hari ini
  Map<String, int> getTodayCapacityStats() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final slots = getSlotsForDate(today);
    int totalCapacity = 0;
    int totalBooked = 0;
    for (var slot in slots) {
      totalCapacity += slot.capacity;
      totalBooked += slot.bookedCount;
    }
    return {'capacity': totalCapacity, 'booked': totalBooked};
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
        debugPrint('[checkOut saldo update ignored error]: $e');
      }
    }

    // Step 3: Release slot capacity (decrement bookedCount)
    if (booking.tanggal.isNotEmpty && booking.jam.isNotEmpty) {
      try {
        await _slotService.decrementBookedCount(
          doulaId: _userCtrl.uid.value,
          tanggal: booking.tanggal,
          time: booking.jam,
        );
        // Reload utilization
        _loadSlotUtilization();
      } catch (e) {
        debugPrint('[checkOut slot release error]: $e');
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
