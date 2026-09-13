import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class UserSettingNotifikasiController extends GetxController {
  final RxBool toggleUpdateApplikasi = false.obs;
  final RxBool toggleTagihan = false.obs;
  final RxBool toggleDiskon = false.obs;
  final RxBool toggleLayananTerbaru = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    toggleUpdateApplikasi.value = prefs.getBool('notif_update_app') ?? false;
    toggleTagihan.value = prefs.getBool('notif_tagihan') ?? false;
    toggleDiskon.value = prefs.getBool('notif_diskon') ?? false;
    toggleLayananTerbaru.value = prefs.getBool('notif_layanan_terbaru') ?? false;
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_update_app', toggleUpdateApplikasi.value);
    await prefs.setBool('notif_tagihan', toggleTagihan.value);
    await prefs.setBool('notif_diskon', toggleDiskon.value);
    await prefs.setBool('notif_layanan_terbaru', toggleLayananTerbaru.value);
  }

  void updateToggleUpdateApplikasi(bool value) {
    toggleUpdateApplikasi.value = value;
    _savePrefs();
  }

  void updateToggleTagihan(bool value) {
    toggleTagihan.value = value;
    _savePrefs();
  }

  void updateToggleDiskon(bool value) {
    toggleDiskon.value = value;
    _savePrefs();
  }

  void updateToggleLayananTerbaru(bool value) {
    toggleLayananTerbaru.value = value;
    _savePrefs();
  }
}
