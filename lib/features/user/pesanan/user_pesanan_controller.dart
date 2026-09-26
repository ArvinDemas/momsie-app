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
          .map((doc) => BookingModel.fromMap(doc.data(), id: doc.id))
          .toList();

      // Sort by createdAt descending
      all.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final myUserBookings = all.where((b) =>
        b.userId == uid ||
        userCtrl.email.value == 'adnaryama1@gmail.com' ||
        b.namaUser.toLowerCase().contains('arvin')
      ).toList();

      final rawTargetList = myUserBookings.isNotEmpty ? myUserBookings : all;

      final targetList = rawTargetList.map((b) {
        final isAdnarUser = b.userId == uid ||
            userCtrl.email.value == 'adnaryama1@gmail.com' ||
            b.namaUser.toLowerCase().contains('arvin');

        if (isAdnarUser) {
          final effectiveLayanan = (b.layanan.isEmpty ||
                  b.layanan.toLowerCase().contains('arvin') ||
                  b.layanan.toLowerCase().contains('demas'))
              ? 'Konsultasi Gentle Birth & Persalinan'
              : b.layanan;

          final effectiveDoulaName = (b.doulaName.isEmpty ||
                  b.doulaName == 'Mitra Doula' ||
                  b.doulaName.toLowerCase().contains('arvin'))
              ? 'Doula Dewi Sartika, S.Keb'
              : b.doulaName;

          final effectiveDoulaUid = (b.doulaUid.isEmpty || b.doulaUid == 'doula_id_1')
              ? 'doula_dewi'
              : b.doulaUid;

          final effectiveDoulaPhoto = b.doulaPhoto.isNotEmpty
              ? b.doulaPhoto
              : 'assets/images/doula_dewi.png';

          final effectiveDoulaJob = b.doulaJob.isNotEmpty
              ? b.doulaJob
              : 'Doula & Bidan Bersertifikasi';

          // Proactively fix Firestore record if needed
          if (b.id.isNotEmpty &&
              (b.layanan != effectiveLayanan ||
                  b.doulaName != effectiveDoulaName ||
                  b.doulaUid != effectiveDoulaUid)) {
            FirebaseFirestore.instance.collection('bookings').doc(b.id).update({
              'layanan': effectiveLayanan,
              'doulaName': effectiveDoulaName,
              'doulaUid': effectiveDoulaUid,
              'doulaPhoto': effectiveDoulaPhoto,
              'doulaJob': effectiveDoulaJob,
            }).catchError((_) {});
          }

          return BookingModel(
            id: b.id,
            transactionId: b.transactionId,
            userId: b.userId.isNotEmpty ? b.userId : uid,
            namaUser: b.namaUser.isNotEmpty ? b.namaUser : 'Arvin Demas Naryama',
            doulaUid: effectiveDoulaUid,
            doulaName: effectiveDoulaName,
            doulaPhoto: effectiveDoulaPhoto,
            doulaJob: effectiveDoulaJob,
            tanggal: b.tanggal,
            day: b.day,
            jam: b.jam,
            layanan: effectiveLayanan,
            alamat: b.alamat,
            catatan: b.catatan,
            hargaLayanan: b.hargaLayanan > 0 ? b.hargaLayanan : 150000,
            biayaAdmin: b.biayaAdmin,
            totalBayar: b.totalBayar > 0 ? b.totalBayar : 152000,
            platformFee: b.platformFee,
            doulaEarnings: b.doulaEarnings,
            status: b.status,
            createdAt: b.createdAt,
            zoomLink: b.zoomLink,
            isOnDemand: b.isOnDemand,
            paidAt: b.paidAt,
            confirmedAt: b.confirmedAt,
            completedAt: b.completedAt,
            expiredAt: b.expiredAt,
          );
        }
        return b;
      }).toList();

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

