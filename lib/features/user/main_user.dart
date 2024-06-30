import 'package:douce/features/user/akun/user_akun_page.dart';
import 'package:douce/features/user/beranda/user_beranda_page.dart';
import 'package:douce/features/user/edukasi/user_edukasi_page.dart';
import 'package:douce/features/user/kesehatan/user_kesehatan_page.dart';
import 'package:douce/features/user/obat/user_obat_page.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainUserPage extends StatelessWidget {
  const MainUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainUserController mainUserController = Get.put(MainUserController());

    return Scaffold(
      backgroundColor: ColorDouce.grayBackground,
      body: Obx(
        () =>
            mainUserController.pageList[mainUserController.selectedIndex.value],
      ),
      bottomNavigationBar: NavBar(
        listItems: const [
          {'label': 'Beranda', 'count': '0'},
          {'label': 'Kesehatan', 'count': '1'},
          {'label': 'Obat', 'count': '2'},
          {'label': 'Edukasi', 'count': '3'},
          {'label': 'Akun', 'count': '4'},
        ],
        onChangeIndex: mainUserController.onItemTapped,
      ),
    );
  }
}

class MainUserController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pageList = const [
    UserBerandaPage(),
    UserKesehatanPage(),
    UserObatPage(),
    UserEdukasiPage(),
    UserAkunPage(),
  ];
}
