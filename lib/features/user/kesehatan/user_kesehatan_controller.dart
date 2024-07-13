import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:douce/shared/util/service/rumahsakit_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserKesehatanController extends GetxController {
  GoogleMapController? mapController;
  Position? currentPosition;

  RxString nameSelected = ''.obs;
  RumahSakitModel? rumahSakitSelected;

  final RxList<RumahSakitModel> listRumahSakit = <RumahSakitModel>[].obs;
  final RxList<RumahSakitModel> listFilteredRumahSakit =
      <RumahSakitModel>[].obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() async {
    getRumahsakit().then((_) {
      determinePosition().then((_) {
        isLoading.value = false;
      });
    });
    super.onInit();
  }

  RxString kesehatanType = "Rumah Sakit".obs;
  RxString searchValue = "".obs;

  void changeType(String value) {
    kesehatanType.value = value;
    update();
  }

  void onSearch(String value) {
    searchValue.value = value;
    if (searchValue.value.isEmpty) {
      listFilteredRumahSakit.clear();
      return;
    }

    listFilteredRumahSakit.value = listRumahSakit
        .where((element) => element.nama.toLowerCase().contains(value))
        .toList();
  }

  Future<void> getRumahsakit() async {
    listRumahSakit.value = await RumahSakitService().getRumahSakit();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    currentPosition = await Geolocator.getCurrentPosition();
  }

  void updateCameraPosition(double latitude, double longitude) {
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    mapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void updateSelected(RumahSakitModel rumahSakit) {
    rumahSakitSelected = rumahSakit;
    nameSelected.value = rumahSakit.nama;

    updateCameraPosition(
      rumahSakit.latitude,
      rumahSakit.longitude,
    );
  }
}
