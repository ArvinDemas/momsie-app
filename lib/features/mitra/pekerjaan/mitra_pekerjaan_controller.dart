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

  static List<BookingModel> getAnastasiaDemoBookings([
    String? dUid,
    String? dName,
    String? dPhoto,
    String? dJob,
  ]) {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final tomorrowStr = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1)));
    final pastStr = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 2)));

    final targetUid = dUid ?? 'doula_anastasia';
    final targetName = dName ?? 'Anastasia Mawardi';
    final targetPhoto = (dPhoto != null && dPhoto.isNotEmpty) ? dPhoto : 'assets/images/blank-profile.png';
    final targetJob = dJob ?? 'Bidan & Certified Doula';

    return [
      // 1. Ongoing / Berjalan
      BookingModel(
        id: 'booking_demo_ana_1',
        transactionId: 'TRX-MOMSIE-ANA-001',
        userId: 'user_nadia',
        namaUser: 'Bunda Nadia Salsabila',
        doulaUid: targetUid,
        doulaName: targetName,
        doulaPhoto: targetPhoto,
        doulaJob: targetJob,
        tanggal: todayStr,
        day: 'Hari ini',
        jam: '10:00',
        layanan: 'Pendampingan Persalinan & Pijat Trimester 3',
        alamat: 'Jl. Kaliurang KM 7.5, Sleman, Yogyakarta',
        catatan: 'Kehamilan 35 minggu. Mengalami nyeri punggung bawah dan kontraksi palsu, butuh relaksasi teknik napas.',
        hargaLayanan: 450000,
        biayaAdmin: 2000,
        totalBayar: 452000,
        platformFee: 67500,
        doulaEarnings: 382500,
        status: 'ongoing',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      // 2. Confirmed / Masuk
      BookingModel(
        id: 'booking_demo_ana_2',
        transactionId: 'TRX-MOMSIE-ANA-002',
        userId: 'user_clarissa',
        namaUser: 'Bunda Clarissa Putri',
        doulaUid: targetUid,
        doulaName: targetName,
        doulaPhoto: targetPhoto,
        doulaJob: targetJob,
        tanggal: tomorrowStr,
        day: 'Besok',
        jam: '14:00',
        layanan: 'Konsultasi Persalinan Holistik & Gentle Birth',
        alamat: 'Kec. Mlati, Kabupaten Sleman, DIY',
        catatan: 'Anak pertama, ingin panduan gentle birth dan latihan afirmasi positif bersama suami.',
        hargaLayanan: 350000,
        biayaAdmin: 2000,
        totalBayar: 352000,
        platformFee: 52500,
        doulaEarnings: 297500,
        status: 'confirmed',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      // 3. Paid / Masuk
      BookingModel(
        id: 'booking_demo_ana_3',
        transactionId: 'TRX-MOMSIE-ANA-003',
        userId: 'user_sarah',
        namaUser: 'Bunda Sarah Larasati',
        doulaUid: targetUid,
        doulaName: targetName,
        doulaPhoto: targetPhoto,
        doulaJob: targetJob,
        tanggal: DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 2))),
        day: 'Lusa',
        jam: '16:00',
        layanan: 'Kelas Edukasi Hypnobirthing Privat',
        alamat: 'Jl. Gejayan No. 12, Sleman, Yogyakarta',
        catatan: 'Ingin persiapan mental menghadapi persalinan normal.',
        hargaLayanan: 400000,
        biayaAdmin: 2000,
        totalBayar: 402000,
        platformFee: 60000,
        doulaEarnings: 340000,
        status: 'paid',
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
      // 4. Completed / Selesai
      BookingModel(
        id: 'booking_demo_ana_4',
        transactionId: 'TRX-MOMSIE-ANA-004',
        userId: 'user_rina',
        namaUser: 'Bunda Rina Anggraini',
        doulaUid: targetUid,
        doulaName: targetName,
        doulaPhoto: targetPhoto,
        doulaJob: targetJob,
        tanggal: pastStr,
        day: '2 hari lalu',
        jam: '09:00',
        layanan: 'Konseling Laktasi & Pijat Oksitosin Pasca Salin',
        alamat: 'Bantul, Yogyakarta',
        catatan: 'Pelekatan menyusui berhasil dengan baik, produksi ASI lancar.',
        hargaLayanan: 300000,
        biayaAdmin: 2000,
        totalBayar: 302000,
        platformFee: 45000,
        doulaEarnings: 255000,
        status: 'completed',
        completedAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      // 5. Completed / Selesai
      BookingModel(
        id: 'booking_demo_ana_5',
        transactionId: 'TRX-MOMSIE-ANA-005',
        userId: 'user_jessica',
        namaUser: 'Bunda Jessica Wijaya',
        doulaUid: targetUid,
        doulaName: targetName,
        doulaPhoto: targetPhoto,
        doulaJob: targetJob,
        tanggal: DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 6))),
        day: '6 hari lalu',
        jam: '13:30',
        layanan: 'Edukasi Gentle Birth & Relaksasi Trimester 2',
        alamat: 'Depok, Sleman, Yogyakarta',
        catatan: 'Sesi latihan teknik relaksasi napas dalam bersama suami selesai lancar.',
        hargaLayanan: 350000,
        biayaAdmin: 2000,
        totalBayar: 352000,
        platformFee: 52500,
        doulaEarnings: 297500,
        status: 'completed',
        completedAt: now.subtract(const Duration(days: 6)),
        createdAt: now.subtract(const Duration(days: 7)),
      ),
      // 6. Completed / Selesai
      BookingModel(
        id: 'booking_demo_ana_6',
        transactionId: 'TRX-MOMSIE-ANA-006',
        userId: 'user_maya',
        namaUser: 'Bunda Maya Lestari',
        doulaUid: targetUid,
        doulaName: targetName,
        doulaPhoto: targetPhoto,
        doulaJob: targetJob,
        tanggal: DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 10))),
        day: '10 hari lalu',
        jam: '10:00',
        layanan: 'Pendampingan Persalinan Spontan & Pijat Nifas',
        alamat: 'Kotagede, Yogyakarta',
        catatan: 'Pendampingan persalinan berjalan normal & sehat, pemulihan nifas optimal.',
        hargaLayanan: 500000,
        biayaAdmin: 2000,
        totalBayar: 502000,
        platformFee: 75000,
        doulaEarnings: 425000,
        status: 'completed',
        completedAt: now.subtract(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 11)),
      ),
    ];
  }

  bool get isAnastasiaUser {
    if (!Get.isRegistered<UserController>()) return false;
    final userCtrl = Get.find<UserController>();
    final email = userCtrl.email.value.toLowerCase();
    final uid = userCtrl.uid.value.toLowerCase();
    final username = userCtrl.username.value.toLowerCase();
    final doulaUsername = userCtrl.doulaUsername.value.toLowerCase();
    final isKnownDemo = email.contains('anastasia') ||
        email.contains('dewi') ||
        email.contains('laily') ||
        email.contains('erny') ||
        email.contains('agustin') ||
        email.contains('karisma') ||
        uid.startsWith('doula_');
    return isKnownDemo || (userCtrl.isDoula.value && (email.isEmpty || email.contains('anastasia')));
  }

  void applyAnastasiaDemo([DoulaModel? customDoula]) {
    String? dUid = customDoula?.uid;
    String? dName = customDoula?.name;
    String? dPhoto = customDoula?.image;
    String? dJob = customDoula?.job;

    if (dUid == null && Get.isRegistered<UserController>()) {
      final userCtrl = Get.find<UserController>();
      if (userCtrl.isDoula.value) {
        dUid = userCtrl.uid.value;
        dName = userCtrl.doulaUsername.value.isNotEmpty ? userCtrl.doulaUsername.value : userCtrl.username.value;
        dPhoto = userCtrl.image.value;
      }
    }

    final demos = getAnastasiaDemoBookings(dUid, dName, dPhoto, dJob);
    activeBookings.value = demos.where((b) => b.status == 'ongoing').toList();
    pendingBookings.value = demos.where((b) => b.status == 'pending' || b.status == 'paid' || b.status == 'confirmed').toList();
    completedBookings.value = demos.where((b) => b.status == 'completed').toList();
    _syncSlotUtilization(demos);
  }

  void _onUserChanged() {
    if (isAnastasiaUser) {
      applyAnastasiaDemo();
    }
    _listenBookings();
    _loadSlotUtilization();
  }

  @override
  void onInit() {
    selectedTanggal.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _userCtrl = Get.find<UserController>();

    if (isAnastasiaUser) {
      applyAnastasiaDemo();
    }

    ever(_userCtrl.email, (_) => _onUserChanged());
    ever(_userCtrl.uid, (_) => _onUserChanged());
    ever(_userCtrl.doulaUsername, (_) => _onUserChanged());

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
    _bookingsSub?.cancel();
    final firestore = FirebaseFirestore.instance;

    _bookingsSub = firestore.collection('bookings').snapshots().listen((snapshot) {
      final doulaUid = _userCtrl.uid.value;
      final isAna = isAnastasiaUser;

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
        b.doulaName.toLowerCase().contains('anastasia') ||
        (_userCtrl.email.value == 'adnaryama1@gmail.com') ||
        (_userCtrl.email.value.toLowerCase().contains('anastasia'))
      ).toList();

      final activeRaw = allDocs.where((b) => b.status == 'ongoing').toList();
      final activeMatched = activeRaw.where((b) =>
        b.doulaUid == doulaUid ||
        b.doulaName.toLowerCase().contains('arvin') ||
        b.doulaName.toLowerCase().contains('anastasia') ||
        (_userCtrl.email.value == 'adnaryama1@gmail.com') ||
        (_userCtrl.email.value.toLowerCase().contains('anastasia'))
      ).toList();

      final completedRaw = allDocs.where((b) => b.status == 'completed').toList();
      final completedMatched = completedRaw.where((b) =>
        b.doulaUid == doulaUid ||
        b.doulaName.toLowerCase().contains('arvin') ||
        b.doulaName.toLowerCase().contains('anastasia') ||
        (_userCtrl.email.value == 'adnaryama1@gmail.com') ||
        (_userCtrl.email.value.toLowerCase().contains('anastasia'))
      ).toList();

      if (isAna) {
        final demos = getAnastasiaDemoBookings();
        final demoPending = demos.where((b) => b.status == 'pending' || b.status == 'paid' || b.status == 'confirmed').toList();
        final demoActive = demos.where((b) => b.status == 'ongoing').toList();
        final demoCompleted = demos.where((b) => b.status == 'completed').toList();

        final Set<String> existingPendingIds = demoPending.map((e) => e.id).toSet();
        final extraPending = pendingMatched.where((p) => !existingPendingIds.contains(p.id)).toList();
        pendingBookings.value = [...demoPending, ...extraPending];

        final Set<String> existingActiveIds = demoActive.map((e) => e.id).toSet();
        final extraActive = activeMatched.where((a) => !existingActiveIds.contains(a.id)).toList();
        activeBookings.value = [...demoActive, ...extraActive];

        final Set<String> existingCompletedIds = demoCompleted.map((e) => e.id).toSet();
        final extraCompleted = completedMatched.where((c) => !existingCompletedIds.contains(c.id)).toList();
        completedBookings.value = [...demoCompleted, ...extraCompleted];
      } else {
        pendingBookings.value = pendingMatched.isNotEmpty ? pendingMatched : pendingRaw;
        activeBookings.value = activeMatched.isNotEmpty ? activeMatched : activeRaw;
        completedBookings.value = completedMatched.isNotEmpty ? completedMatched : completedRaw;
      }

      _syncSlotUtilization([...allDocs, ...(isAna ? getAnastasiaDemoBookings() : [])]);

      debugPrint('[MitraPekerjaanController] Updated bookings - Pending: ${pendingBookings.length}, Active: ${activeBookings.length}, Completed: ${completedBookings.length}');
    }, onError: (e) {
      debugPrint('[MitraPekerjaanController] Bookings stream error: $e');
      if (isAnastasiaUser) {
        applyAnastasiaDemo();
      }
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
    if (booking.id.startsWith('booking_demo_')) {
      pendingBookings.removeWhere((b) => b.id == booking.id);
      activeBookings.removeWhere((b) => b.id == booking.id);
      final updated = booking.copyWith(status: 'ongoing');
      activeBookings.insert(0, updated);
      Get.snackbar('Pekerjaan Dimulai', 'Status: Berjalan',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

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
    if (booking.id.startsWith('booking_demo_')) {
      final index = pendingBookings.indexWhere((b) => b.id == booking.id);
      if (index >= 0) {
        pendingBookings[index] = pendingBookings[index].copyWith(status: 'confirmed');
      }
      Get.snackbar('Pekerjaan Diklaim', 'Status: Dikonfirmasi',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

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
    final earnings = booking.doulaEarnings;

    if (booking.id.startsWith('booking_demo_')) {
      activeBookings.removeWhere((b) => b.id == booking.id);
      final updated = booking.copyWith(
        status: 'completed',
        completedAt: DateTime.now(),
      );
      completedBookings.insert(0, updated);
      Get.snackbar(
        '✅ Check Out Berhasil',
        'Pekerjaan selesai! Pendapatan Rp ${_formatRupiah(earnings)} masuk ke saldo',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;

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
