import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString uid = ''.obs;
  RxString image = ''.obs;
  RxInt yogaStreak = 0.obs;

  // Pregnancy & Baby Details
  RxString dueDate = '16 Apr 2027'.obs;
  RxString babySex = 'Belum Tahu'.obs;
  RxString babyName = ''.obs;
  RxBool isFirstChild = true.obs;
  RxBool isPregnancyLoss = false.obs;
  RxBool isBabyBorn = false.obs;

  // Maternal Context (Onboarding)
  RxString pregnancyStage = 'none'.obs; // 'none', 'trimester1', 'trimester2', 'trimester3'
  RxBool hasCompletedMaternalContext = false.obs;

  // App Settings
  RxString lengthUnit = 'cm'.obs;
  RxString weightUnit = 'kg'.obs;
  RxBool personalisedAds = true.obs;

  // Account Details
  RxInt age = 26.obs;
  RxString relationship = 'Ibu Hamil / Bunda'.obs;

  @override
  void onInit() {
    super.onInit();
    loadYogaStreak();
    loadProfileSettings();
  }

  Future<void> loadYogaStreak() async {
    final prefs = await SharedPreferences.getInstance();
    yogaStreak.value = prefs.getInt('yoga_streak') ?? 0;
  }

  Future<void> loadProfileSettings() async {
    final prefs = await SharedPreferences.getInstance();
    dueDate.value = prefs.getString('due_date') ?? '16 Apr 2027';
    babySex.value = prefs.getString('baby_sex') ?? 'Belum Tahu';
    babyName.value = prefs.getString('baby_name') ?? '';
    isFirstChild.value = prefs.getBool('is_first_child') ?? true;
    isPregnancyLoss.value = prefs.getBool('is_pregnancy_loss') ?? false;
    isBabyBorn.value = prefs.getBool('is_baby_born') ?? false;
    lengthUnit.value = prefs.getString('length_unit') ?? 'cm';
    weightUnit.value = prefs.getString('weight_unit') ?? 'kg';
    personalisedAds.value = prefs.getBool('personalised_ads') ?? true;
    age.value = prefs.getInt('user_age') ?? 26;
    relationship.value = prefs.getString('user_relationship') ?? 'Ibu Hamil / Bunda';
    pregnancyStage.value = prefs.getString('pregnancy_stage') ?? 'none';
    hasCompletedMaternalContext.value = prefs.getBool('has_completed_maternal_context') ?? false;
  }

  Future<void> updateDueDate(String newDate) async {
    dueDate.value = newDate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('due_date', newDate);
  }

  Future<void> updateBabySex(String sex) async {
    babySex.value = sex;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baby_sex', sex);
  }

  Future<void> updateBabyName(String name) async {
    babyName.value = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baby_name', name);
  }

  Future<void> updateIsFirstChild(bool value) async {
    isFirstChild.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_child', value);
  }

  Future<void> updateIsPregnancyLoss(bool value) async {
    isPregnancyLoss.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_pregnancy_loss', value);
  }

  Future<void> updateIsBabyBorn(bool value) async {
    isBabyBorn.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_baby_born', value);
  }

  Future<void> updateLengthUnit(String unit) async {
    lengthUnit.value = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('length_unit', unit);
  }

  Future<void> updateWeightUnit(String unit) async {
    weightUnit.value = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weight_unit', unit);
  }

  Future<void> updatePersonalisedAds(bool value) async {
    personalisedAds.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('personalised_ads', value);
  }

  Future<void> updateAge(int newAge) async {
    age.value = newAge;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_age', newAge);
  }

  Future<void> updateRelationship(String rel) async {
    relationship.value = rel;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_relationship', rel);
  }

  Future<void> updatePregnancyStage(String stage) async {
    pregnancyStage.value = stage;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pregnancy_stage', stage);
  }

  Future<void> setMaternalContextComplete() async {
    hasCompletedMaternalContext.value = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_maternal_context', true);
  }

  void resetMaternalContext() {
    pregnancyStage.value = 'none';
    hasCompletedMaternalContext.value = false;
  }

  RxBool isDoula = false.obs;

  RxString doulaUsername = ''.obs;
  RxString doulaAlamat = ''.obs;
  RxString doulaKotaProvinsi = ''.obs;
  RxString doulaBiografi = ''.obs;
  RxString doulaImage = ''.obs;
  RxString doulaJenisKelamin = ''.obs;
  // TODO: NIK adalah data PII sensitif. Pertimbangkan untuk tidak menyimpannya di state reaktif,
  // atau gunakan secure storage (FlutterSecureStorage) untuk penyimpanan lokal.
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

  Future<void> updateUsername(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    username.value = trimmed;
    doulaUsername.value = trimmed;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', trimmed);
      await prefs.setString('user_name', trimmed);
      await prefs.setString('doula_name', trimmed);
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving username to prefs: $e');
    }

    try {
      final curUser = FirebaseAuth.instance.currentUser;
      if (curUser != null) {
        await curUser.updateDisplayName(trimmed);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating Firebase display name: $e');
    }

    final targetUid = uid.value.isNotEmpty ? uid.value : (FirebaseAuth.instance.currentUser?.uid ?? '');
    if (targetUid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('user').doc(targetUid).set({
          'username': trimmed,
          'name': trimmed,
        }, SetOptions(merge: true));
      } catch (e) {
        if (kDebugMode) debugPrint('Error updating user doc: $e');
      }

      try {
        await FirebaseFirestore.instance.collection('mitra').doc(targetUid).set({
          'name': trimmed,
          'username': trimmed,
        }, SetOptions(merge: true));
      } catch (e) {
        if (kDebugMode) debugPrint('Error updating mitra doc: $e');
      }
    }
  }
}
