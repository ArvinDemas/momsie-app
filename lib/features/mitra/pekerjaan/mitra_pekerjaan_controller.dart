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

  @override
  void onInit() {
    selectedTanggal.value =
        (DateTime.now().add(const Duration(days: 1)).day.toString());
    getPekerjaan();
    getActive();
    getRiwayat();

    super.onInit();
  }

  List<DateTime> dates =
      List.generate(5, (i) => DateTime.now().add(Duration(days: i + 1)));

  Future<void> getPekerjaan() async {
    try {
      final List<PesananModel> pekerjaanList =
          await PesananService().getPekerjaan(true);
      pekerjaan.assignAll(pekerjaanList);
      await Future.delayed(const Duration(seconds: 1));
      getPekerjaan();
    } catch (e) {
      // print(e);
      await Future.delayed(const Duration(seconds: 1));
      getPekerjaan();
    }
  }

  Future<void> getActive() async {
    try {
      final List<ActiveModel> activeList =
          await ActiveService().getActive(true);
      active.assignAll(activeList);

      await Future.delayed(const Duration(seconds: 1));
      getActive();
    } catch (e) {
      // print(e);
    }
  }

  Future<void> getRiwayat() async {
    try {
      final List<ActiveModel> riwayatList =
          await ActiveService().getRiwayat(true);
      riwayat.assignAll(riwayatList);

      await Future.delayed(const Duration(seconds: 1));
      getRiwayat();
    } catch (e) {
      // print(e);
    }
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
    } catch (e) {
      print(e);
    }
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
    } catch (e) {
      // print(e);
    }
  }
}
