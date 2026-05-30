import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:douce/shared/util/service/pesanan_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraPekerjaanController extends GetxController {
  final RxString selectedTanggal = ''.obs;
  final RxString currentMonth = DateFormat('MMMM').format(DateTime.now()).obs;
  final RxString currentYear = DateTime.now().year.toString().obs;

  final RxList<PesananModel> pekerjaan = <PesananModel>[].obs;
  final RxList<ActiveModel> active = <ActiveModel>[].obs;
  final RxList<ActiveModel> riwayat = <ActiveModel>[].obs;

  StreamSubscription<QuerySnapshot>? _pekerjaanSub;
  StreamSubscription<QuerySnapshot>? _activeSub;
  StreamSubscription<QuerySnapshot>? _riwayatSub;

  @override
  void onInit() {
    selectedTanggal.value =
        (DateTime.now().add(const Duration(days: 1)).day.toString());
    _listenPekerjaan();
    _listenActive();
    _listenRiwayat();
    super.onInit();
  }

  @override
  void onClose() {
    _pekerjaanSub?.cancel();
    _activeSub?.cancel();
    _riwayatSub?.cancel();
    super.onClose();
  }

  List<DateTime> dates =
      List.generate(5, (i) => DateTime.now().add(Duration(days: i + 1)));

  void _listenPekerjaan() {
    final firestore = FirebaseFirestore.instance;
    _pekerjaanSub = firestore.collection('pekerjaan').snapshots().listen(
      (snapshot) async {
        try {
          final List<String> userIds =
              snapshot.docs.map((doc) => doc['user'] as String).toList();
          final Map<String, String> usernameMap =
              await PesananService().fetchUsernamesPublic(userIds);

          final List<PesananModel> result = snapshot.docs.map((doc) {
            final String uid = doc['user'] as String;
            return PesananModel(
              id: doc['id'],
              pemesan: uid,
              tanggal: doc['tanggal'],
              day: doc['day'],
              jam: doc['jam'],
              layanan: doc['layanan'],
              harga: doc['harga'].toString(),
              namaUser: usernameMap[uid] ?? '',
            );
          }).toList();
          pekerjaan.assignAll(result);
        } catch (_) {}
      },
    );
  }

  void _listenActive() {
    final firestore = FirebaseFirestore.instance;
    final UserController userController = Get.find<UserController>();
    _activeSub = firestore
        .collection('active')
        .where('doula', isEqualTo: userController.uid.value)
        .snapshots()
        .listen(
      (snapshot) async {
        try {
          final List<String> userIds =
              snapshot.docs.map((doc) => doc['user'] as String).toList();
          final List<String> doulaIds =
              snapshot.docs.map((doc) => doc['doula'] as String).toList();
          final Map<String, String> usernameMap =
              await PesananService().fetchUsernamesPublic(userIds);
          final Map<String, String> doulaNameMap =
              await PesananService().fetchDolaNamePublic(doulaIds);

          final List<ActiveModel> result = snapshot.docs.map((doc) {
            final String uid = doc['user'] as String;
            final String doulaId = doc['doula'] as String;
            return ActiveModel(
              id: doc['id'],
              pemesan: uid,
              doula: doulaId,
              tanggal: doc['tanggal'],
              day: doc['day'],
              jam: doc['jam'],
              layanan: doc['layanan'],
              harga: doc['harga'].toString(),
              namaUser: usernameMap[uid] ?? '',
              namaDoula: doulaNameMap[doulaId] ?? '',
            );
          }).toList();
          active.assignAll(result);
        } catch (_) {}
      },
    );
  }

  void _listenRiwayat() {
    final firestore = FirebaseFirestore.instance;
    final UserController userController = Get.find<UserController>();
    _riwayatSub = firestore
        .collection('riwayat')
        .where('doula', isEqualTo: userController.uid.value)
        .snapshots()
        .listen(
      (snapshot) async {
        try {
          final List<String> userIds =
              snapshot.docs.map((doc) => doc['user'] as String).toList();
          final List<String> doulaIds =
              snapshot.docs.map((doc) => doc['doula'] as String).toList();
          final Map<String, String> usernameMap =
              await PesananService().fetchUsernamesPublic(userIds);
          final Map<String, String> doulaNameMap =
              await PesananService().fetchDolaNamePublic(doulaIds);

          final List<ActiveModel> result = snapshot.docs.map((doc) {
            final String uid = doc['user'] as String;
            final String doulaId = doc['doula'] as String;
            return ActiveModel(
              id: doc['id'],
              pemesan: uid,
              doula: doulaId,
              tanggal: doc['tanggal'],
              day: doc['day'],
              jam: doc['jam'],
              layanan: doc['layanan'],
              harga: doc['harga'].toString(),
              namaUser: usernameMap[uid] ?? '',
              namaDoula: doulaNameMap[doulaId] ?? '',
            );
          }).toList();
          riwayat.assignAll(result);
        } catch (_) {}
      },
    );
  }

  Future<void> klaimPekerjaan(PesananModel pekerjaan) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final UserController userController = Get.find<UserController>();

      await firestore.runTransaction((transaction) async {
        final querySnapshot = await firestore
            .collection('pekerjaan')
            .where('id', isEqualTo: pekerjaan.id)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await firestore.collection('active').add({
            'id': pekerjaan.id,
            'user': pekerjaan.pemesan,
            'doula': userController.uid.value,
            'tanggal': pekerjaan.tanggal,
            'day': pekerjaan.day,
            'jam': pekerjaan.jam,
            'layanan': pekerjaan.layanan,
            'harga': pekerjaan.harga,
            'namaUser': pekerjaan.namaUser,
            'namaDoula': userController.doulaUsername.value,
          });

          await firestore
              .collection('pekerjaan')
              .where('id', isEqualTo: pekerjaan.id)
              .get()
              .then((value) {
            for (var element in value.docs) {
              element.reference.delete();
            }
          });
        } else {
          Get.snackbar('Error', 'Pekerjaan sudah diambil');
        }
      });
    } catch (_) {}
  }

  Future<void> checkOut(ActiveModel active) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('riwayat').add({
        'id': active.id,
        'user': active.pemesan,
        'doula': active.doula,
        'tanggal': active.tanggal,
        'day': active.day,
        'jam': active.jam,
        'layanan': active.layanan,
        'harga': active.harga,
        'namaUser': active.namaUser,
        'namaDoula': active.namaDoula,
      });

      await firestore
          .collection('active')
          .where('id', isEqualTo: active.id)
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });

      await firestore.collection('mitra').doc(active.doula).update({
        'saldo': FieldValue.increment(int.parse(active.harga)),
      });
    } catch (_) {}
  }
}
