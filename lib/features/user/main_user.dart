import 'package:douce/features/user/akun/user_akun_page.dart';
import 'package:douce/features/user/beranda/user_beranda_page.dart';
import 'package:douce/features/user/edukasi/user_edukasi_page.dart';
import 'package:douce/features/user/kesehatan/user_kesehatan_controller.dart';
import 'package:douce/features/user/kesehatan/user_kesehatan_page.dart';
import 'package:douce/features/user/obat/user_obat_page.dart';
import 'package:douce/shared/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainUserPage extends StatelessWidget {
  const MainUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainUserController mainUserController = Get.put(MainUserController());
    final List<Widget> pageList = [
      UserBerandaPage(
        changeNavigation: (String changeController) {
          if (!Get.isRegistered<UserKesehatanController>()) {
            Get.put(UserKesehatanController());
          }
          Get.find<UserKesehatanController>().kesehatanType.value =
              changeController;
          mainUserController.onItemTapped(1);
        },
      ),
      const UserKesehatanPage(),
      const UserEdukasiPage(),
      const UserAkunPage(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(
          () => pageList[mainUserController.selectedIndex.value],
        ),
        bottomNavigationBar: Obx(
          () => NavBar(
            listItems: const [
              {'label': 'Beranda', 'count': 0},
              {'label': 'Kesehatan', 'count': 1},
              {'label': 'Edukasi', 'count': 2},
              {'label': 'Akun', 'count': 3},
            ],
            onChangeIndex: mainUserController.onItemTapped,
            selectedIndex: mainUserController.selectedIndex.value,
          ),
        ),
      ),
    );
  }
}

class MainUserController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxString kesehatanController = "Rumah Sakit".obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
