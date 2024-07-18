import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:douce/shared/util/service/pesanan_service.dart';
import 'package:get/get.dart';

class UserPesananController extends GetxController {
  final RxString selectedPesanan = "Aktif".obs;

  final RxList<PesananModel> pesanan = <PesananModel>[].obs;
  final RxList<PesananModel> pekerjaan = <PesananModel>[].obs;
  final RxList<ActiveModel> active = <ActiveModel>[].obs;
  final RxList<ActiveModel> riwayat = <ActiveModel>[].obs;

  @override
  void onInit() {
    getPesanan();
    getPekerjaan();
    getActive();
    getRiwayat();
    super.onInit();
  }

  void changeSelectedPesanan(String pesanan) {
    selectedPesanan.value = pesanan;
  }

  Future<void> getPesanan() async {
    try {
      final List<PesananModel> pesananList =
          await PesananService().getPesanan();
      pesanan.assignAll(pesananList);
    } catch (e) {
      // print(e);
    }
  }

  Future<void> getPekerjaan() async {
    try {
      final List<PesananModel> pekerjaanList =
          await PesananService().getPekerjaan(false);
      pekerjaan.assignAll(pekerjaanList);
    } catch (e) {
      // print(e);
    }
  }

  Future<void> getActive() async {
    try {
      final List<ActiveModel> activeList =
          await ActiveService().getActive(false);
      active.assignAll(activeList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getRiwayat() async {
    try {
      final List<ActiveModel> riwayatList =
          await ActiveService().getRiwayat(false);
      riwayat.assignAll(riwayatList);
    } catch (e) {
      print(e);
    }
  }
}
