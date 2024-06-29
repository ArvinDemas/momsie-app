import 'package:douce/features/mitra/akun/mitra_akun_page.dart';
import 'package:douce/features/mitra/beranda/mitra_beranda_page.dart';
import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_page.dart';
import 'package:douce/features/mitra/status/mitra_status_page.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainMitraPage extends StatelessWidget {
  const MainMitraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainMitraController mitraController = Get.put(MainMitraController());
    return Scaffold(
      backgroundColor: ColorDouce.grayBackground,
      body: Obx(
        () => mitraController.pageList[mitraController.selectedIndex.value],
      ),
      bottomNavigationBar: NavBar(
        listItems: const [
          {'label': 'Beranda', 'count': '0'},
          {'label': 'Pekerjaan', 'count': '1'},
          {'label': 'Status', 'count': '2'},
          {'label': 'Akun', 'count': '3'},
        ],
        onChangeIndex: mitraController.onItemTapped,
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
    MitraStatusPage(),
    MitraAkunPage(),
  ];
}
