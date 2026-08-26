import 'package:douce/features/mitra/beranda/mitra_beranda_page.dart';
import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart';
import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_page.dart';
import 'package:douce/features/mitra/pendapatan/mitra_pendapatan_page.dart';
import 'package:douce/features/mitra/profil/mitra_aturjadwal_page.dart';
import 'package:douce/shared/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainMitraPage extends StatelessWidget {
  const MainMitraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainMitraController mitraController = Get.put(MainMitraController());
    Get.put(MitraPekerjaanController());
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(
          () => mitraController.pageList[mitraController.selectedIndex.value],
        ),
        bottomNavigationBar: Obx(
          () => NavBar(
            isMitra: true,
            listItems: const [
              {'label': 'Beranda', 'count': 0},
              {'label': 'Pekerjaan', 'count': 1},
              {'label': 'Jadwal', 'count': 2},
              {'label': 'Pendapatan', 'count': 3},
            ],
            onChangeIndex: mitraController.onItemTapped,
            selectedIndex: mitraController.selectedIndex.value,
          ),
        ),
      ),
    );
  }
}

class MainMitraController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pageList = const [
    MitraBerandaPage(),
    MitraPekerjaanPage(),
    MitraAturJadwalPage(),
    MitraPendapatanPage(),
  ];
}
