import 'package:douce/features/user/kesehatan/user_kesehatan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/doula_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserKesehatanPage extends StatelessWidget {
  const UserKesehatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserKesehatanController controller =
        Get.put(UserKesehatanController());

    return Obx(() => BasePage(
      searchHint: controller.kesehatanType.value == "Doula"
          ? "Cari Doula..."
          : "Cari Rumah Sakit...",
      onSearchChanged: controller.onSearch,
      childWidget: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _typeButton(controller, "Doula"),
                const SizedBox(width: 16),
                _typeButton(controller, "Rumah Sakit"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.kesehatanType.value == "Rumah Sakit") {
                return _rumahSakitPlaceholder();
              }
              return _doulaColumn(controller);
            }),
          ),
        ],
      ),
    ));
  }

  Widget _typeButton(UserKesehatanController controller, String label) {
    return Obx(() {
      final isSelected = controller.kesehatanType.value == label;
      return InkWell(
        onTap: () => controller.changeType(label),
        borderRadius: BorderRadius.circular(26),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 24),
          decoration: BoxDecoration(
            color: isSelected ? ColorDouce.douceBase : Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: ColorDouce.douceBase),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }

  /// Placeholder untuk RS — tampil "Segera Hadir"
  Widget _rumahSakitPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_hospital_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            "Fitur Segera Hadir",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Direktori Rumah Sakit Mitra\nakan hadir dalam pembaruan berikutnya.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _doulaColumn(UserKesehatanController controller) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        InkWell(
          onTap: () => Get.toNamed('booking-doula'),
          child: Center(
            child: Image.asset("assets/images/beranda.png"),
          ),
        ),
        const SizedBox(height: 30),
        Obx(() {
          final list = controller.searchValue.value.isEmpty
              ? controller.doulaList
              : controller.listFilteredDoula;
          if (list.isEmpty) {
            return const Center(
              child: Text("Tidak ada doula ditemukan",
                  style: TextStyle(color: Colors.black45)),
            );
          }
          return Wrap(
            spacing: 10,
            runSpacing: 50,
            alignment: WrapAlignment.spaceAround,
            children: list
                .map((DoulaModel doula) => DoulaContainer(doula: doula))
                .toList(),
          );
        }),
        const SizedBox(height: 30),
      ],
    );
  }
}
