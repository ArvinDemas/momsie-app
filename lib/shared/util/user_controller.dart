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
}
