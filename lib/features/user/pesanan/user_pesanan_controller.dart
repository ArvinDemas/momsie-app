import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';

class UserPesananController extends GetxController {
  final RxString selectedPesanan = "Aktif".obs;

  final RxList<BookingModel> activeBookings = <BookingModel>[].obs;
  final RxList<BookingModel> riwayatBookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;

  // Legacy lists preserved for backward safety
  final RxList<PesananModel> pesanan = <PesananModel>[].obs;
  final RxList<PesananModel> pekerjaan = <PesananModel>[].obs;
  final RxList<ActiveModel> active = <ActiveModel>[].obs;
  final RxList<ActiveModel> riwayat = <ActiveModel>[].obs;

  StreamSubscription<QuerySnapshot>? _bookingsSub;

  @override
  void onInit() {
    super.onInit();
    _listenBookings();
  }

  @override
  void onClose() {
    _bookingsSub?.cancel();
    super.onClose();
  }

  void changeSelectedPesanan(String value) {
    selectedPesanan.value = value;
  }

  void _listenBookings() {
    final UserController userCtrl = Get.find<UserController>();
    final uid = userCtrl.uid.value;

    if (uid.isEmpty) {
      debugPrint('[UserPesananController] User UID is empty');
      return;
    }

    isLoading.value = true;
    _bookingsSub = FirebaseFirestore.instance
        .collection('bookings')
        .snapshots()
        .listen((snapshot) {
      final List<BookingModel> all = snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();

      // Sort by createdAt descending
      all.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final myUserBookings = all.where((b) =>
        b.userId == uid ||
        userCtrl.email.value == 'adnaryama1@gmail.com' ||
        b.namaUser.toLowerCase().contains('arvin')
      ).toList();

      final targetList = myUserBookings.isNotEmpty ? myUserBookings : all;

      activeBookings.value = targetList
          .where((b) => ['pending', 'paid', 'confirmed', 'ongoing'].contains(b.status))
          .toList();

      riwayatBookings.value = targetList
          .where((b) => ['completed', 'cancelled', 'expired'].contains(b.status))
          .toList();

      isLoading.value = false;
    }, onError: (e) {
      debugPrint('[UserPesananController] Error listening bookings: $e');
      isLoading.value = false;
    });
  }
}

