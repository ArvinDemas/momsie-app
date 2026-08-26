import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:douce/shared/util/service/booking_slot_service.dart';
import 'package:douce/shared/util/service/payment_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDoulaController extends GetxController {
  final RxInt harga = 0.obs;
  final RxString selectedTanggal = ''.obs;
  final RxString selectedDay = ''.obs;
  final RxString selectedJam = ''.obs;
  final RxString selectedLayanan = ''.obs;
  final RxString alamatUser = ''.obs;
  final RxString catatanUser = ''.obs;

  // Calendar State
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString viewMode = 'bulanan'.obs; // 'bulanan', 'mingguan'

  final Rx<DoulaModel?> selectedDoula = Rx<DoulaModel?>(null);
  final RxBool isLoadingSlots = false.obs;
  final RxList<String> availableSlots = <String>[].obs;
  final RxString errorMessage = ''.obs;

  final DateFormat _dateStorageFmt = DateFormat('yyyy-MM-dd');
  final DateFormat monthYearFormat = DateFormat('MMMM yyyy');

  late final BookingSlotService _slotService;

  @override
  void onInit() {
    super.onInit();
    _slotService = BookingSlotService();
    if (Get.arguments != null && Get.arguments['doula'] != null) {
      selectedDoula.value = Get.arguments['doula'] as DoulaModel;
    }
    // Default set ke hari ini
    onDateSelected(selectedDate.value);
  }

  void setDoula(DoulaModel doula) {
    selectedDoula.value = doula;
    if (selectedTanggal.value.isNotEmpty) {
      _loadAvailableSlots(selectedTanggal.value);
    }
  }

  void changeMonth(int delta) {
    final newDate = DateTime(focusedMonth.value.year, focusedMonth.value.month + delta, 1);
    focusedMonth.value = newDate;
    onDateSelected(newDate);
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    if (date.month != focusedMonth.value.month || date.year != focusedMonth.value.year) {
      focusedMonth.value = DateTime(date.year, date.month, 1);
    }
    selectedTanggal.value = _dateStorageFmt.format(date);
    selectedDay.value = DateFormat('E').format(date);
    selectedJam.value = '';
    _loadAvailableSlots(selectedTanggal.value);
  }

  void setHarga(int value) {
    harga.value = value;
  }

  void setSelectedJam(String value) {
    selectedJam.value = value;
  }

  void setSelectedLayanan(String value) {
    selectedLayanan.value = value;
  }

  /// Load slot ketersediaan Doula dari Firestore
  Future<void> _loadAvailableSlots(String tanggal) async {
    if (selectedDoula.value == null) {
      // Warm fallback slots jika Doula belum diset dari list
      availableSlots.value = ['09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00'];
      errorMessage.value = '';
      return;
    }

    isLoadingSlots.value = true;
    errorMessage.value = '';

    try {
      final doulaId = selectedDoula.value!.uid;

      final slotDoc = await _slotService.getSlot(doulaId, tanggal);
      final bookedSlots = await _slotService.getBookedSlots(
        doulaId: doulaId,
        tanggalList: [tanggal],
      );

      final booked = bookedSlots[tanggal] ?? [];

      if (slotDoc != null && slotDoc.slots.isNotEmpty) {
        availableSlots.value = slotDoc.slots.where((s) => !booked.contains(s)).toList();
      } else {
        // Fallback default jam operasional jika Doula baru terdaftar
        final defaultSlots = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];
        availableSlots.value = defaultSlots.where((s) => !booked.contains(s)).toList();
      }

      if (availableSlots.isEmpty) {
        errorMessage.value = 'Semua jam pada tanggal ini telah penuh terisi / tidak tersedia.';
      }
    } catch (e) {
      debugPrint('Error loading user slots: $e');
      errorMessage.value = 'Gagal memuat jadwal ketersediaan.';
      availableSlots.value = [];
    } finally {
      isLoadingSlots.value = false;
    }
  }

  BookingModel toBookingModel() {
    final userController = Get.isRegistered<UserController>() ? Get.find<UserController>() : null;
    final doula = selectedDoula.value;

    final hargaLayananVal = harga.value;
    const biayaAdminVal = 2000;
    final totalVal = hargaLayananVal + biayaAdminVal;

    final split = PaymentService.calculateSplit(hargaLayananVal);

    return BookingModel(
      id: '',
      transactionId: '',
      userId: userController?.uid.value ?? 'guest',
      namaUser: userController?.username.value.isNotEmpty == true
          ? userController!.username.value
          : 'Pengguna Momsie',
      doulaUid: doula?.uid ?? 'doula_id_1',
      doulaName: doula?.name ?? 'Bidan / Doula',
      doulaPhoto: doula?.image ?? '',
      doulaJob: doula?.job ?? 'Pendamping Persalinan',
      tanggal: selectedTanggal.value,
      day: selectedDay.value,
      jam: selectedJam.value,
      layanan: selectedLayanan.value,
      alamat: alamatUser.value,
      catatan: catatanUser.value,
      hargaLayanan: hargaLayananVal,
      biayaAdmin: biayaAdminVal,
      totalBayar: totalVal,
      platformFee: split['platformFee'] ?? 0,
      doulaEarnings: split['doulaEarnings'] ?? 0,
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }

  void resetSelection() {
    harga.value = 0;
    selectedTanggal.value = '';
    selectedDay.value = '';
    selectedJam.value = '';
    selectedLayanan.value = '';
    alamatUser.value = '';
    catatanUser.value = '';
    selectedDoula.value = null;
    availableSlots.value = [];
    errorMessage.value = '';
  }
}
