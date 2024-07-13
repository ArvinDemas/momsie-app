import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:douce/shared/util/service/artikel_service.dart';
import 'package:douce/shared/util/service/program_service.dart';
import 'package:get/get.dart';

class UserEdukasiController extends GetxController {
  final RxString edukasi = "Artikel".obs;

  final RxBool isLoadingArtikel = true.obs;
  RxList<ArtikelModel> artikelList = <ArtikelModel>[].obs;

  final RxBool isLoadingProgram = true.obs;
  RxList<ProgramModel> programList = <ProgramModel>[].obs;

  @override
  void onInit() {
    getArtikel().then((_) {
      isLoadingArtikel.value = false;
    });
    getProgram().then((_) {
      isLoadingProgram.value = false;
    });
    super.onInit();
  }

  void changeEdukasi(String value) {
    edukasi.value = value;
  }

  Future<void> getArtikel() async {
    final List<ArtikelModel> artikel = await ArtikelService().getArtikel();
    if (artikel.isNotEmpty) {
      artikelList.assignAll(artikel);
    }
  }

  Future<void> getProgram() async {
    List<ProgramModel> program = await ProgramService().getProgram();
    if (program.isNotEmpty) {
      programList.assignAll(program);
    }
  }
}
