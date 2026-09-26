import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/model/booking_slot_model.dart';
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
  final RxString viewMode = 'bulanan'.obs;

  final Rx<DoulaModel?> selectedDoula = Rx<DoulaModel?>(null);
  final RxBool isLoadingSlots = false.obs;
  final RxList<SlotItem> availableSlots = <SlotItem>[].obs;
  final RxString errorMessage = ''.obs;

  final DateFormat _dateStorageFmt = DateFormat('yyyy-MM-dd');
  final DateFormat monthYearFormat = DateFormat('MMMM yyyy');

  late final BookingSlotService _slotService;

  // Service type classification
  static const Set<String> scheduledServices = {
    'chat_doula',
    'prenatal_yoga',
    'doula_offline',
    'Konsultasi Online via Chat',
    'Kelas Online: Prenatal Yoga',
    'Full Journey Doula Care',
  };

  static const Set<String> onDemandServices = {
    'materi_online',
    'paket_bundling',
    'Kelas Online: Materi Prenatal',
    'Kelas Online: Bundling Edukasi & Yoga',
  };

  static const Map<String, int> servicePrices = {
    'chat_doula': 30000,
    'materi_online': 99000,
    'prenatal_yoga': 75000,
    'paket_bundling': 135000,
    'doula_offline': 3000000,
    'Konsultasi Online via Chat': 30000,
    'Kelas Online: Materi Prenatal': 99000,
    'Kelas Online: Prenatal Yoga': 75000,
    'Kelas Online: Bundling Edukasi & Yoga': 135000,
    'Full Journey Doula Care': 3000000,
  };

  static const Map<String, String> serviceLabels = {
    'chat_doula': 'Konsultasi Online via Chat',
    'materi_online': 'Kelas Online: Materi Prenatal',
    'prenatal_yoga': 'Kelas Online: Prenatal Yoga',
    'paket_bundling': 'Kelas Online: Bundling Edukasi & Yoga',
    'doula_offline': 'Full Journey Doula Care',
  };

  static String normalizeLayananKey(String val) {
    switch (val) {
      case 'Konsultasi Online via Chat':
        return 'chat_doula';
      case 'Kelas Online: Materi Prenatal':
        return 'materi_online';
      case 'Kelas Online: Prenatal Yoga':
        return 'prenatal_yoga';
      case 'Kelas Online: Bundling Edukasi & Yoga':
        return 'paket_bundling';
      case 'Full Journey Doula Care':
        return 'doula_offline';
      default:
        return val;
    }
  }

  bool get isOnDemand {
    final k = normalizeLayananKey(selectedLayanan.value);
    return onDemandServices.contains(k) || onDemandServices.contains(selectedLayanan.value);
  }

  bool get isScheduled {
    if (selectedLayanan.value.isEmpty) return true;
    final k = normalizeLayananKey(selectedLayanan.value);
    return scheduledServices.contains(k) || scheduledServices.contains(selectedLayanan.value);
  }

  @override
  void onInit() {
    super.onInit();
    _slotService = BookingSlotService();
    if (Get.arguments != null && Get.arguments['doula'] != null) {
      selectedDoula.value = Get.arguments['doula'] as DoulaModel;
    } else if (selectedDoula.value == null && DummyData.doulas.isNotEmpty) {
      selectedDoula.value = DummyData.doulas.first;
    }
    // Default to 'Konsultasi Online via Chat' so slots & calendar are available immediately!
    if (selectedLayanan.value.isEmpty) {
      setSelectedLayanan('Konsultasi Online via Chat');
    }
    onDateSelected(selectedDate.value);
  }

  void setDoula(DoulaModel doula) {
    selectedDoula.value = doula;
    if (selectedTanggal.value.isNotEmpty && isScheduled) {
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
    if (value.isEmpty) {
      selectedTanggal.value = '';
      selectedDay.value = '';
      selectedJam.value = '';
      availableSlots.value = [];
      return;
    }
    final price = servicePrices[value] ?? (servicePrices[normalizeLayananKey(value)] ?? 0);
    harga.value = price;
    if (isScheduled && selectedTanggal.value.isNotEmpty) {
      _loadAvailableSlots(selectedTanggal.value);
    }
  }

  List<SlotItem> _generateDemoSlotsForDoula(String doulaId, String tanggal) {
    final List<String> allTimes = ['09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '19:00'];
    final DateTime? parsedDate = DateTime.tryParse(tanggal);
    final int daySeed = parsedDate != null ? (parsedDate.day + parsedDate.month) : 1;
    final idLower = doulaId.toLowerCase();

    return allTimes.map((t) {
      bool isBooked = false;
      final int hour = int.tryParse(t.split(':')[0]) ?? 9;

      if (idLower.contains('dewi')) {
        // Dewi Riana: 09:00, 13:00, dan bergantian jam 15:00 penuh
        isBooked = (hour == 9 || hour == 13 || (daySeed % 2 == 0 && hour == 15));
      } else if (idLower.contains('laily')) {
        // Laily: 10:00, 14:00, dan bergantian jam 16:00 penuh
        isBooked = (hour == 10 || hour == 14 || (daySeed % 2 == 1 && hour == 16));
      } else if (idLower.contains('erny')) {
        // Erny: 09:00, 11:00, dan bergantian jam 16:00 penuh
        isBooked = (hour == 9 || hour == 11 || (daySeed % 3 == 0 && hour == 16));
      } else if (idLower.contains('agustin')) {
        // Agustin: 10:00, 13:00, dan bergantian jam 15:00 penuh
        isBooked = (hour == 10 || hour == 13 || (daySeed % 2 == 0 && hour == 15));
      } else if (idLower.contains('karisma')) {
        // Karisma: 11:00, 14:00, dan bergantian jam 16:00 penuh
        isBooked = (hour == 11 || hour == 14 || (daySeed % 2 == 1 && hour == 16));
      } else if (idLower.contains('anastasia')) {
        // Anastasia: 09:00, 13:00, dan bergantian jam 19:00 penuh
        isBooked = (hour == 9 || hour == 13 || (daySeed % 2 == 0 && hour == 19));
      } else {
        isBooked = ((hour + daySeed) % 4 == 0);
      }

      return SlotItem(
        time: t,
        capacity: 1,
        bookedCount: isBooked ? 1 : 0,
      );
    }).toList();
  }

  Future<void> _loadAvailableSlots(String tanggal) async {
    if (selectedDoula.value == null) {
      availableSlots.value = [];
      errorMessage.value = 'Pilih doula terlebih dahulu.';
      return;
    }

    isLoadingSlots.value = true;
    errorMessage.value = '';

    try {
      final doulaId = selectedDoula.value!.uid;
      final slotDoc = await _slotService.getSlot(doulaId, tanggal);

      if (slotDoc != null && slotDoc.slots.isNotEmpty) {
        availableSlots.value = slotDoc.slots;
      } else {
        // Generate realistic slots for top doulas
        availableSlots.value = _generateDemoSlotsForDoula(doulaId, tanggal);
      }

      // Check booked status from bookings collection (if any real bookings exist in Firestore)
      final bookedSlots = await _slotService.getBookedSlots(
        doulaId: doulaId,
        tanggalList: [tanggal],
      );
      final booked = bookedSlots[tanggal] ?? [];

      // Mark booked slots
      for (var slot in availableSlots) {
        if (booked.contains(slot.time)) {
          final index = availableSlots.indexWhere((s) => s.time == slot.time);
          if (index >= 0) {
            final updated = availableSlots[index].copyWith(bookedCount: slot.capacity);
            availableSlots[index] = updated;
          }
        }
      }

      errorMessage.value = availableSlots.isEmpty ? 'Semua jam pada tanggal ini telah penuh terisi.' : '';
    } catch (e) {
      debugPrint('Error loading user slots: $e');
      final doulaId = selectedDoula.value?.uid ?? 'doula_dewi';
      availableSlots.value = _generateDemoSlotsForDoula(doulaId, tanggal);
      errorMessage.value = '';
    } finally {
      isLoadingSlots.value = false;
    }
  }

  bool get canProceed {
    if (selectedDoula.value == null) return false;
    if (selectedLayanan.value.isEmpty) return false;
    if (isScheduled) {
      if (selectedTanggal.value.isEmpty || selectedJam.value.isEmpty) return false;
    }
    if (normalizeLayananKey(selectedLayanan.value) == 'doula_offline' && alamatUser.value.trim().isEmpty) return false;
    return true;
  }

  BookingModel toBookingModel() {
    final userController = Get.isRegistered<UserController>() ? Get.find<UserController>() : null;
    final doula = selectedDoula.value;
    final layanan = selectedLayanan.value;

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
      layanan: layanan,
      alamat: normalizeLayananKey(selectedLayanan.value) == 'doula_offline' ? alamatUser.value : null,
      catatan: catatanUser.value,
      hargaLayanan: hargaLayananVal,
      biayaAdmin: biayaAdminVal,
      totalBayar: totalVal,
      platformFee: split['platformFee'] ?? 0,
      doulaEarnings: split['doulaEarnings'] ?? 0,
      status: 'pending',
      isOnDemand: isOnDemand,
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
