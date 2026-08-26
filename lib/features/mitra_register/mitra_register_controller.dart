import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/service/app_config_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MitraRegisterController extends GetxController {
  final RxInt currentPage = 0.obs;
  final RxString jobSelect = ''.obs;
  final RxString educationSelect = ''.obs;
  final RxString religionSelect = ''.obs;
  final RxString genderSelect = ''.obs;

  final Rx<File?> currentImage = Rx<File?>(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController nohpController = TextEditingController();
  final TextEditingController kotaProvinsiController = TextEditingController();
  final TextEditingController biografiController = TextEditingController();

  void changePage(int page) {
    currentPage.value = page;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (currentImage.value != null) {
        currentImage.value = null;
      }
      currentImage.value = File(pickedFile.path);
    }
  }

  Future<void> submitRegister() async {
    try {
      if (nameController.text.isEmpty ||
          nikController.text.isEmpty ||
          nohpController.text.isEmpty ||
          kotaProvinsiController.text.isEmpty) {
        Get.snackbar('Error', 'Lengkapi data diri di halaman pertama',
            snackPosition: SnackPosition.TOP);
        return;
      }
      if (religionSelect.value.isEmpty ||
          genderSelect.value.isEmpty ||
          jobSelect.value.isEmpty ||
          educationSelect.value.isEmpty) {
        Get.snackbar('Error', 'Lengkapi pilihan agama, gender, pekerjaan, dan pendidikan',
            snackPosition: SnackPosition.TOP);
        return;
      }
      if (biografiController.text.isEmpty) {
        Get.snackbar('Error', 'Biografi tidak boleh kosong',
            snackPosition: SnackPosition.TOP);
        return;
      }
      if (currentImage.value == null) {
        Get.snackbar('Error', 'Foto profil wajib diupload',
            snackPosition: SnackPosition.TOP);
        return;
      }
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final UserController userController = Get.find<UserController>();

      // Show loading while saving photo locally
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Save photo to local storage (same pattern as diary - no Firebase Storage cost)
      final appDir = await getApplicationDocumentsDirectory();
      final mitraDir = Directory('${appDir.path}/mitra_photos');
      if (!await mitraDir.exists()) {
        await mitraDir.create(recursive: true);
      }
      final String ext = currentImage.value!.path.split('.').last;
      final String localPath =
          '${mitraDir.path}/${userController.uid.value}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      await currentImage.value!.copy(localPath);

      Get.back(); // close loading

      // Buat/Update dokumen mitra
      await firestore.collection('mitra').doc(userController.uid.value).set({
        'name': nameController.text,
        'nik': nikController.text,
        'nohp': nohpController.text,
        'biografi': biografiController.text,
        'pekerjaan': jobSelect.value,
        'pendidikan': educationSelect.value,
        'agama': religionSelect.value,
        'jenisKelamin': genderSelect.value,
        'kotaProvinsi': kotaProvinsiController.text,
        'alamat': kotaProvinsiController.text,  // Simpan juga sebagai 'alamat' agar kompatibel dengan DoulaModel
        'image': localPath,
        'rating': 5.0,
        'saldo': 0,
        'saldo_tersedia': 0,
        'saldo_escrow': 0,
        'totalPendapatan': 0,
      }, SetOptions(merge: true));

      // PENTING: Update field isDoula di collection 'user' agar login mendeteksi role mitra
      await firestore.collection('user').doc(userController.uid.value).update({
        'isDoula': true,
      }).catchError((_) async {
        // Jika document belum ada, buat baru dengan isDoula: true
        await firestore.collection('user').doc(userController.uid.value).set({
          'isDoula': true,
        }, SetOptions(merge: true));
      });

      final int randomNumber = getRandomNumber();

      // Cek feature flag: jika showPaymentFlow = false (mode review Google Play),
      // jangan buat dokumen register dan jangan arahkan ke halaman OVO
      final AppConfigService configService = Get.find<AppConfigService>();

      // Setelah selesai registrasi, arahkan ke halaman SOP untuk approval
      // Doula akan masuk ke flow mitra setelah SOP disetujui
      Get.offAllNamed('/sop-waiting');
    } catch (e) {
      // Make sure loading dialog is closed if Firestore write fails
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    nikController.dispose();
    nohpController.dispose();
    kotaProvinsiController.dispose();
    biografiController.dispose();
    super.onClose();
  }

  int getRandomNumber() {
    return 50000 + DateTime.now().millisecondsSinceEpoch % 1000;
  }

  Rx<List<String>> genderList = Rx<List<String>>([
    'Laki-laki',
    'Perempuan',
  ]);
  Rx<List<String>> religionList = Rx<List<String>>([
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Budha',
    'Konghucu',
  ]);
  Rx<List<String>> educationList = Rx<List<String>>([
    'SD',
    'SMP',
    'SMA',
    'D3',
    'S1',
    'S2',
    'S3',
  ]);
  Rx<List<String>> jobList = Rx<List<String>>([
    'Dokter',
    'Perawat',
    'PNS',
    'TNI',
    'POLRI',
    'Pegawai Swasta',
    'Wiraswasta',
    'Petani',
    'Nelayan',
    'Buruh',
    'Lainnya',
  ]);
}
