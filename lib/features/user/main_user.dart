import 'package:douce/features/user/beranda/user_beranda_controller.dart';
import 'package:douce/features/user/beranda/user_beranda_page.dart';
import 'package:douce/features/user/edukasi/user_edukasi_page.dart';
import 'package:douce/features/user/eksplor/user_eksplor_page.dart';
import 'package:douce/features/user/kesehatan/user_kesehatan_controller.dart';
import 'package:douce/features/user/kesehatan/user_kesehatan_page.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// StatefulWidget agar pages list tidak di-recreate ulang setiap Obx rebuild
// (mencegah assertion error !semantics.parentDataDirty pada IndexedStack + Obx)
class MainUserPage extends StatefulWidget {
  const MainUserPage({super.key});

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
  late final MainUserController mainUserController;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    mainUserController = Get.put(MainUserController());

    // Pre-register UserBerandaController permanen SEBELUM UserBerandaPage dibuat
    if (!Get.isRegistered<UserBerandaController>()) {
      Get.put(UserBerandaController(), permanent: true);
    }

    // Buat pages SEKALI di initState — tidak di-recreate saat rebuild
    pages = [
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
      const UserEksplorPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        // IndexedStack mempertahankan seluruh tab di memory — Beranda tidak pernah blank
        body: Obx(
          () => Material(
            color: Colors.transparent,
            child: IndexedStack(
              index: mainUserController.selectedIndex.value,
              children: pages,
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => NavBar(
            listItems: const [
              {'label': 'Beranda', 'count': 0},
              {'label': 'Doula', 'count': 1},
              {'label': 'Edukasi', 'count': 2},
              {'label': 'Eksplor', 'count': 3},
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

  /// Called from inner pages (Beranda, etc.) to switch the bottom nav tab.
  /// Automatically initializes UserController if not yet registered.
  void switchTab(int index) {
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController());
    }
    onItemTapped(index);
  }
}
