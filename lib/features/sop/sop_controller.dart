import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SopController extends GetxController {
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;

  // Step 1: Data Diri
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController nohpController = TextEditingController();
  final TextEditingController kotaProvinsiController = TextEditingController();
  final RxString roleSelect = 'Doula'.obs;

  // Step 2: Persetujuan
  final RxBool agreeTerms = false.obs;
  final RxBool agreeRules = false.obs;
  final RxBool agreeValidation = false.obs;
  final Rx<String?> ktpImage = Rx<String?>(null);
  final Rx<String?> sertifikatImage = Rx<String?>(null);

  // Step 3: Tanda Tangan (handled in widget)
  bool get isSignatureDone => true; // Simplified - will be passed from widget

  void nextStep() {
    if (currentStep.value == 0) {
      if (nameController.text.isEmpty ||
          nikController.text.isEmpty ||
          nohpController.text.isEmpty ||
          kotaProvinsiController.text.isEmpty) {
        Get.snackbar('Error', 'Lengkapi semua data diri',
            snackPosition: SnackPosition.TOP);
        return;
      }
    }
    if (currentStep.value == 1) {
      if (!agreeTerms.value || !agreeRules.value || !agreeValidation.value) {
        Get.snackbar('Error', 'Centang semua pernyataan persetujuan',
            snackPosition: SnackPosition.TOP);
        return;
      }
      if (ktpImage.value == null) {
        Get.snackbar('Error', 'Upload foto KTP/Identitas',
            snackPosition: SnackPosition.TOP);
        return;
      }
    }
    currentStep.value++;
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> pickKtpImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      ktpImage.value = picked.path;
    }
  }

  Future<void> pickSertifikatImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      sertifikatImage.value = picked.path;
    }
  }

  Future<void> submitSOP() async {
    isLoading.value = true;

    try {
      final UserController userController = Get.find<UserController>();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final FirebaseStorage storage = FirebaseStorage.instance;

      // Upload KTP
      String? ktpUrl;
      if (ktpImage.value != null) {
        final ref = storage.ref().child('sop_ktp/${userController.uid.value}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(File(ktpImage.value!));
        ktpUrl = await ref.getDownloadURL();
      }

      // Upload Sertifikat (optional)
      String? sertifikatUrl;
      if (sertifikatImage.value != null) {
        final ref = storage.ref().child('sop_sertifikat/${userController.uid.value}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(File(sertifikatImage.value!));
        sertifikatUrl = await ref.getDownloadURL();
      }

      // Create SOP submission document
      await firestore.collection('sop_submissions').add({
        'userId': userController.uid.value,
        'userEmail': userController.email.value,
        'userName': nameController.text,
        'nik': nikController.text,
        'nohp': nohpController.text,
        'kotaProvinsi': kotaProvinsiController.text,
        'role': roleSelect.value.toLowerCase(),
        'status': 'pending',
        'rejectionReason': null,
        'submittedAt': FieldValue.serverTimestamp(),
        'ktpUrl': ktpUrl,
        'sertifikatUrl': sertifikatUrl,
        'csMessage': null,
        'agreedTerms': true,
      });

      // Mark user as having submitted SOP
      await firestore.collection('user').doc(userController.uid.value).update({
        'hasSubmittedSOP': true,
      });

      Get.snackbar(
        'Berhasil!',
        'Pendaftaran SOP Anda telah dikirim. Menunggu verifikasi admin.',
        snackPosition: SnackPosition.TOP,
      );

      Get.offAllNamed('/sop-waiting');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim SOP: $e',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    nikController.dispose();
    nohpController.dispose();
    kotaProvinsiController.dispose();
    super.onClose();
  }
}
