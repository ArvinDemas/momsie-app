import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/service/booking_slot_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraAturJadwalController extends GetxController {
  final UserController _userController = Get.find<UserController>();

  // Calendar State
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString viewMode = 'bulanan'.obs; // 'bulanan', 'mingguan', 'harian'

  // State per tanggal (yyyy-MM-dd): list jam yang aktif
  final RxMap<String, List<String>> slotState = <String, List<String>>{}.obs;
  final RxBool isLoading = false.obs;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat monthYearFormat = DateFormat('MMMM yyyy');

  @override
  void onInit() {
    super.onInit();
    loadMonthSlots(focusedMonth.value);
  }

  String getDoulaId() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser?.uid != null && firebaseUser!.uid.isNotEmpty) {
      return firebaseUser.uid;
    }
    if (_userController.uid.value.isNotEmpty) {
      return _userController.uid.value;
    }
    return '';
  }

  void changeMonth(int monthDelta) {
    final newDate = DateTime(focusedMonth.value.year, focusedMonth.value.month + monthDelta, 1);
    focusedMonth.value = newDate;
    selectedDate.value = newDate;
    loadMonthSlots(newDate);
  }

  void setFocusedDate(DateTime date) {
    selectedDate.value = date;
    if (date.month != focusedMonth.value.month || date.year != focusedMonth.value.year) {
      focusedMonth.value = DateTime(date.year, date.month, 1);
      loadMonthSlots(focusedMonth.value);
    }
  }

  /// Load slot dari Firestore untuk bulan & tahun yang dipilih
  Future<void> loadMonthSlots(DateTime month) async {
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
          .where('tanggal', isGreaterThanOrEqualTo: startStr)
          .where('tanggal', isLessThanOrEqualTo: endStr)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final slots = (data['slots'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final tanggal = data['tanggal'] as String? ?? '';
        if (tanggal.isNotEmpty) {
          slotState[tanggal] = slots;
        }
      }
    } catch (e) {
      debugPrint('Error loading month slots: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle jam tertentu pada tanggal tertentu
  void toggleJam(String tanggal, String jam) {
    final current = List<String>.from(slotState[tanggal] ?? []);
    if (current.contains(jam)) {
      current.remove(jam);
    } else {
      current.add(jam);
      current.sort();
    }
    slotState[tanggal] = current;
  }

  /// Presets: Jam kerja normal (09:00 - 17:00)
  void setPresetNormal(String tanggal) {
    slotState[tanggal] = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];
  }

  /// Presets: Jam malam (18:00 - 21:00)
  void setPresetNight(String tanggal) {
    slotState[tanggal] = ['18:00', '19:00', '20:00', '21:00'];
  }

  /// Presets: Semua Jam (08:00 - 21:00)
  void setPresetAllDay(String tanggal) {
    slotState[tanggal] = [
      '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
      '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00'
    ];
  }

  /// Presets: Kosongkan Hari Ini
  void clearDaySlots(String tanggal) {
    slotState[tanggal] = [];
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
    final month = focusedMonth.value.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(year, month, i);
      if (date.weekday >= DateTime.monday && date.weekday <= DateTime.friday) {
        final tglStr = dateFormat.format(date);
        slotState[tglStr] = List.from(currentSlots);
      }
    }

    Get.snackbar('Berhasil', 'Jadwal diterapkan ke seluruh hari kerja bulan ${monthYearFormat.format(focusedMonth.value)}',
        backgroundColor: Colors.green.shade700, colorText: Colors.white);
  }

  /// Simpan semua slot ke Firestore
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
              'slots': slots,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
        }
      }

      await batch.commit();
      Get.snackbar(
        'Tersimpan! 🎉',
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
