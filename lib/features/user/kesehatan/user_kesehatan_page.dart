import 'package:douce/features/user/kesehatan/google_maps_controller.dart';
import 'package:douce/features/user/kesehatan/user_kesehatan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:douce/shared/widget/doula_container.dart';
import 'package:douce/shared/widget/rumah_sakit_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserKesehatanPage extends StatelessWidget {
  const UserKesehatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserKesehatanController userKesehatanController =
        Get.put(UserKesehatanController());
    final GoogleMapsController mapcontroller = Get.put(GoogleMapsController());
    final TextEditingController searchController = TextEditingController();

    return Stack(
      children: [
        Obx(
          () => userKesehatanController.kesehatanType.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : userKesehatanController.kesehatanType.value == "Doula"
                  ? doulaColumn()
                  : rumahSakitColum(mapcontroller),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                searchTextField(searchController),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        userKesehatanController.changeType("Rumah Sakit");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color:
                                userKesehatanController.kesehatanType.value ==
                                        "Rumah Sakit"
                                    ? ColorDouce.douceBase
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Rumah Sakit",
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  userKesehatanController.kesehatanType.value ==
                                          "Rumah Sakit"
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        userKesehatanController.changeType("Doula");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color:
                                userKesehatanController.kesehatanType.value ==
                                        "Doula"
                                    ? ColorDouce.douceBase
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Doula",
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  userKesehatanController.kesehatanType.value ==
                                          "Doula"
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget searchTextField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            size: 26,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          hintText: "Cari Rumah Sakit atau Dokter",
          hintStyle: const TextStyle(
            color: Colors.black45,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget rumahSakitColum(GoogleMapsController controller) {
    return Stack(
      children: [
        Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  onMapCreated: (GoogleMapController googleMapController) {
                    controller.mapController = googleMapController;
                    controller.updateCameraPosition(
                      controller.currentPosition!.latitude,
                      controller.currentPosition!.longitude,
                    );
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-6.1753924, 106.8271528),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('Lokasi Kamu'),
                      position: LatLng(controller.currentPosition!.latitude,
                          controller.currentPosition!.longitude),
                      infoWindow: const InfoWindow(title: 'Lokasi Kamu'),
                      alpha: 0.7,
                    ),
                    if (controller.nameSelected.value.isNotEmpty)
                      Marker(
                        markerId: MarkerId(controller.rumahSakitSelected!.nama),
                        position: LatLng(
                          controller.rumahSakitSelected!.latitude,
                          controller.rumahSakitSelected!.longitude,
                        ),
                        onTap: () => {
                          Get.toNamed(
                            '/detail-rumah-sakit',
                            arguments: controller.rumahSakitSelected!,
                          ),
                        },
                      ),
                  },
                ),
        ),
        Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: controller.listRumahSakit
                          .map((RumahSakitModel rumahSakit) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: RumahSakitContainer(
                            fullWidth: false,
                            rumahSakit: rumahSakit,
                            onTap: () {
                              controller.updateSelected(rumahSakit);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget doulaColumn() {
    return ListView(
      padding: const EdgeInsets.only(
        top: 210,
        left: 20,
        right: 20,
      ),
      children: const [
        Wrap(
          spacing: 10,
          runSpacing: 50,
          alignment: WrapAlignment.spaceAround,
          children: [
            DoulaContainer(),
            DoulaContainer(),
            DoulaContainer(),
            DoulaContainer(),
            DoulaContainer(),
            DoulaContainer(),
          ],
        ),
      ],
    );
  }
}
