import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/booking_slot_model.dart';
import 'package:douce/shared/util/service/booking_slot_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraAturJadwalController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final BookingSlotService _slotService = BookingSlotService();

  // Calendar State
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString viewMode = 'bulanan'.obs; // 'bulanan', 'mingguan', 'harian'

  // State per tanggal (yyyy-MM-dd): list slot dengan capacity
  final RxMap<String, List<SlotItem>> slotState = <String, List<SlotItem>>{}.obs;
  final RxBool isLoading = false.obs;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat monthYearFormat = DateFormat('MMMM yyyy');

  static const int defaultCapacity = 1;

  @override
  void onInit() {
    super.onInit();
    loadMySlots(focusedMonth.value);
  }

  String getDoulaId() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser?.uid != null && firebaseUser!.uid.isNotEmpty) {
      return firebaseUser.uid;
    }
    if (_userController.uid.value.isNotEmpty) {
      return _userController.uid.value;
    }
    return 'doula_dewi';
  }

  void changeMonth(int monthDelta) {
    final newDate = DateTime(focusedMonth.value.year, focusedMonth.value.month + monthDelta, 1);
    focusedMonth.value = newDate;
    selectedDate.value = newDate;
    loadMySlots(newDate);
  }

  void setFocusedDate(DateTime date) {
    selectedDate.value = date;
    if (date.month != focusedMonth.value.month || date.year != focusedMonth.value.year) {
      focusedMonth.value = DateTime(date.year, date.month, 1);
      loadMySlots(focusedMonth.value);
    }
  }

  /// T-019: Load slot dengan capacity untuk bulan terpilih
  Future<void> loadMySlots(DateTime month) async {
    final doulaId = getDoulaId();
    if (doulaId.isEmpty) return;

    isLoading.value = true;
    final startStr = DateFormat('yyyy-MM-01').format(month);
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    final endStr = DateFormat('yyyy-MM-$lastDay').format(month);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('booking_slots')
          .where('doulaId', isEqualTo: doulaId)
          .get();

      final Map<String, List<SlotItem>> loaded = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final model = BookingSlotModel.fromMap(data, docId: doc.id);
        if (model.tanggal.isNotEmpty &&
            model.tanggal.compareTo(startStr) >= 0 &&
            model.tanggal.compareTo(endStr) <= 0) {
          loaded[model.tanggal] = model.slots;
        }
      }
      slotState.value = loaded;
      slotState.refresh();
    } catch (e) {
      debugPrint('Error loading month slots: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// T-019: Buat/tambah slot baru dengan capacity
  Future<void> createSlot(String tanggal, String time, int capacity) async {
    final doulaId = getDoulaId();
    if (doulaId.isEmpty) {
      Get.snackbar('Perlu Login', 'Silakan login ulang untuk mengatur jadwal.',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
      return;
    }

    // Update lokal dulu
    final current = List<SlotItem>.from(slotState[tanggal] ?? []);
    final existingIndex = current.indexWhere((s) => s.time == time);
    if (existingIndex >= 0) {
      Get.snackbar('Duplikat', 'Slot $time sudah ada. Gunakan edit capacity.',
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }
    current.add(SlotItem(time: time, capacity: capacity, bookedCount: 0));
    current.sort((a, b) => a.time.compareTo(b.time));
    slotState[tanggal] = current;

    // Persist ke Firestore
    try {
      await _slotService.createSlot(
        doulaId: doulaId,
        tanggal: tanggal,
        time: time,
        capacity: capacity,
      );
    } catch (e) {
      debugPrint('Error creating slot: $e');
      Get.snackbar('Gagal', 'Gagal menambah slot: $e',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    }
  }

  /// T-019: Update capacity slot existing
  Future<void> updateSlotCapacity(String tanggal, String time, int newCapacity) async {
    final doulaId = getDoulaId();
    if (doulaId.isEmpty) return;

    // Update lokal
    final current = List<SlotItem>.from(slotState[tanggal] ?? []);
    final index = current.indexWhere((s) => s.time == time);
    if (index < 0) return;

    if (newCapacity < current[index].bookedCount) {
      Get.snackbar('Tidak Boleh', 'Capacity baru ($newCapacity) tidak boleh lebih kecil dari bookedCount (${current[index].bookedCount}).',
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }

    current[index] = current[index].copyWith(capacity: newCapacity);
    slotState[tanggal] = current;

    // Persist
    try {
      await _slotService.updateSlotCapacity(
        doulaId: doulaId,
        tanggal: tanggal,
        time: time,
        newCapacity: newCapacity,
      );
    } catch (e) {
      debugPrint('Error updating capacity: $e');
      Get.snackbar('Gagal', 'Gagal update capacity: $e',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    }
  }

  /// T-019: Hapus slot (hanya jika bookedCount == 0)
  Future<void> deleteSlot(String tanggal, String time) async {
    final doulaId = getDoulaId();
    if (doulaId.isEmpty) return;

    // Validasi lokal
    final current = List<SlotItem>.from(slotState[tanggal] ?? []);
    final index = current.indexWhere((s) => s.time == time);
    if (index < 0) return;

    if (current[index].bookedCount > 0) {
      Get.snackbar('Tidak Bisa Hapus', 'Slot $time sudah memiliki ${current[index].bookedCount} booking aktif.',
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }

    current.removeAt(index);
    slotState[tanggal] = current;

    try {
      await _slotService.deleteSlot(
        doulaId: doulaId,
        tanggal: tanggal,
        time: time,
      );
    } catch (e) {
      debugPrint('Error deleting slot: $e');
      Get.snackbar('Gagal', 'Gagal menghapus slot: $e',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    }
  }

  /// T-019: Ambil booking untuk slot tertentu
  Future<List<Map<String, dynamic>>> getBookingsForSlot(String tanggal, String time) {
    final doulaId = getDoulaId();
    if (doulaId.isEmpty) return Future.value([]);
    return _slotService.getBookingsForSlot(
      doulaId: doulaId,
      tanggal: tanggal,
      time: time,
    );
  }

  /// Toggle jam tertentu pada tanggal tertentu (legacy toggle tanpa capacity)
  void toggleJam(String tanggal, String jam) {
    final current = List<SlotItem>.from(slotState[tanggal] ?? []);
    final existingIndex = current.indexWhere((s) => s.time == jam);
    if (existingIndex >= 0) {
      if (current[existingIndex].bookedCount > 0) {
        Get.snackbar('Tidak Bisa Hapus', 'Slot $jam sudah memiliki booking aktif.',
            backgroundColor: Colors.amber.shade700, colorText: Colors.white);
        return;
      }
      current.removeAt(existingIndex);
    } else {
      current.add(SlotItem(time: jam, capacity: 1, bookedCount: 0));
      current.sort((a, b) => a.time.compareTo(b.time));
    }
    slotState[tanggal] = current;
    slotState.refresh();
  }

  /// Preset: Jam kerja normal (09:00 - 17:00), capacity 1 per slot
  void setPresetNormal(String tanggal) {
    slotState[tanggal] = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00']
        .map((t) => SlotItem(time: t, capacity: defaultCapacity, bookedCount: 0))
        .toList();
    slotState.refresh();
  }

  /// Preset: Jam malam (18:00 - 21:00)
  void setPresetNight(String tanggal) {
    slotState[tanggal] = ['18:00', '19:00', '20:00', '21:00']
        .map((t) => SlotItem(time: t, capacity: defaultCapacity, bookedCount: 0))
        .toList();
    slotState.refresh();
  }

  /// Preset: Semua Jam (08:00 - 21:00)
  void setPresetAllDay(String tanggal) {
    slotState[tanggal] = [
      '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
      '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00',
    ].map((t) => SlotItem(time: t, capacity: defaultCapacity, bookedCount: 0)).toList();
    slotState.refresh();
  }

  /// Preset: Kosongkan Hari Ini (hanya jika tidak ada booking)
  void clearDaySlots(String tanggal) {
    final current = slotState[tanggal] ?? [];
    final hasBookings = current.any((s) => s.bookedCount > 0);
    if (hasBookings) {
      Get.snackbar('Tidak Bisa Kosongkan', 'Ada slot dengan booking aktif. Hapus slot tersebut satu per satu.',
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }
    slotState[tanggal] = [];
    slotState.refresh();
  }

  /// Salin jadwal hari ini ke semua hari kerja (Senin-Jumat) dalam bulan ini
  void applyToAllWorkdaysInMonth(String currentTanggal) {
    final currentSlots = slotState[currentTanggal] ?? [];
    if (currentSlots.isEmpty) {
      Get.snackbar('Perhatian', 'Pilih jam kerja untuk tanggal ini terlebih dahulu',
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }

    final year = focusedMonth.value.year;
    final finalMonth = focusedMonth.value.month;
    final daysInMonth = DateTime(year, finalMonth + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(year, finalMonth, i);
      if (date.weekday >= DateTime.monday && date.weekday <= DateTime.friday) {
        final tglStr = dateFormat.format(date);
        // Skip tanggal yang sudah punya booking aktif
        final existing = slotState[tglStr] ?? [];
        if (existing.any((s) => s.bookedCount > 0)) continue;
        slotState[tglStr] = currentSlots.map((s) => s.copyWith(capacity: s.capacity)).toList();
      }
    }
    slotState.refresh();

    Get.snackbar('Berhasil', 'Jadwal diterapkan ke seluruh hari kerja bulan ${monthYearFormat.format(focusedMonth.value)}',
        backgroundColor: Colors.green.shade700, colorText: Colors.white);
  }

  /// Simpan semua slot ke Firestore (capacity-based)
  Future<void> saveAllSlots() async {
    final doulaId = getDoulaId();

    if (doulaId.isEmpty) {
      Get.snackbar('Perlu Login', 'Silakan login ulang untuk menyimpan jadwal.',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
      return;
    }

    try {
      final batch = FirebaseFirestore.instance.batch();

      for (var entry in slotState.entries) {
        final tanggal = entry.key;
        final slots = entry.value;
        final docId = BookingSlotService.docId(doulaId, tanggal);

        if (slots.isEmpty) {
          batch.delete(FirebaseFirestore.instance.collection('booking_slots').doc(docId));
        } else {
          batch.set(
            FirebaseFirestore.instance.collection('booking_slots').doc(docId),
            {
              'doulaId': doulaId,
              'tanggal': tanggal,
              'slots': slots.map((s) => s.toMap()).toList(),
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
        }
      }

      await batch.commit();
      Get.snackbar(
        'Tersimpan!',
        'Jadwal ketersediaan berhasil diperbarui di cloud',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error saving slots: $e');
      Get.snackbar('Gagal Menyimpan', 'Error: $e',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    }
  }

  String displayDate(DateTime date) => DateFormat('EEEE, dd MMMM yyyy').format(date);
  String storageDate(DateTime date) => dateFormat.format(date);
}
