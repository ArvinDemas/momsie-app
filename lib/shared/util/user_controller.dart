import 'package:get/get.dart';

class UserController extends GetxController {
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString uid = ''.obs;
  RxString image = ''.obs;

  RxBool isDoula = false.obs;

  RxString doulaUsername = ''.obs;
  RxString doulaAlamat = ''.obs;
  RxString doulaKotaProvinsi = ''.obs;
  RxString doulaBiografi = ''.obs;
  RxString doulaImage = ''.obs;
  RxString doulaJenisKelamin = ''.obs;
  RxString doulaNIK = ''.obs;

  void setUser(
    String username,
    String email,
    String uid,
    String image,
    bool isDoula,
  ) {
    this.username.value = username;
    this.email.value = email;
    this.uid.value = uid;
    this.image.value = image;
    this.isDoula.value = isDoula;
  }

  void setDoula(
    String username,
    String alamat,
    String kotaProvinsi,
    String biografi,
    String image,
    String jenisKelamin,
    String nik,
  ) {
    doulaUsername.value = username;
    doulaAlamat.value = alamat;
    doulaKotaProvinsi.value = kotaProvinsi;
    doulaBiografi.value = biografi;
    doulaImage.value = image;
    doulaJenisKelamin.value = jenisKelamin;
    doulaNIK.value = nik;
  }

  void updateUser(String username, bool isDoula, String image) {
    this.username.value = username;
    this.isDoula.value = isDoula;
    this.image.value = image;
  }

  void updateMitra(String name, String alamat, String biografi, String image) {
    doulaUsername.value = name;
    doulaAlamat.value = alamat;
    doulaBiografi.value = biografi;
    doulaImage.value = image;
  }
}
