import 'package:douce/features/user/akun/settings/user_bantuan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserBantuanPage extends StatelessWidget {
  const UserBantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserBantuanController userBantuanController =
        Get.put(UserBantuanController());

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  const Text(
                    "Bantuan",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.heart_broken_rounded,
                    color: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Obx(
                () => helpContainer(
                  "Bagaimana cara melakukan booking Doula?",
                  "Pilih menu Kesehatan di navbar bawah, lalu pilih tab Doula. Klik pada profil Doula yang Anda inginkan, kemudian tekan tombol 'Booking'. Anda akan diarahkan ke halaman pembayaran simulasi.",
                  userBantuanController.bookingDoula.value,
                  userBantuanController.toggleBookingDoula,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => helpContainer(
                  "Bagaimana cara mereset password jika saya lupa?",
                  "Pada halaman Login, klik tautan 'Lupa Password' di bawah tombol login. Masukkan alamat email Anda yang terdaftar, lalu tekan tombol kirim link verifikasi. Periksa kotak masuk atau folder spam email Anda untuk petunjuk pengaturan ulang kata sandi.",
                  userBantuanController.lupaPassword.value,
                  userBantuanController.toggleLupaPassword,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => helpContainer(
                  "Bagaimana cara mengubah tema warna aplikasi?",
                  "Buka menu Pengaturan dari tab Akun Anda, lalu klik menu 'Tema Aplikasi'. Pilih salah satu dari 8 tema warna premium yang tersedia sesuai dengan preferensi kenyamanan visual Anda.",
                  userBantuanController.ubahTema.value,
                  userBantuanController.toggleUbahTema,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => helpContainer(
                  "Bagaimana cara menggunakan Catatan Harian (Pregnancy Diary)?",
                  "Klik menu 'Catatan Harian' di halaman beranda. Tekan tombol '+' untuk menulis catatan baru, pilih mood Anda hari ini, isi usia kehamilan, dan unggah foto perkembangan perut atau USG Anda (maksimal 4 foto).",
                  userBantuanController.catatanKehamilan.value,
                  userBantuanController.toggleCatatanKehamilan,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => helpContainer(
                  "Apakah aplikasi ini membutuhkan API Key untuk AI Chatbot?",
                  "Ya, fitur Momsie AI menggunakan model Gemini-2.0-Flash dengan metode Bring Your Own Key (BYOK). Anda dapat membuat API Key gratis di Google AI Studio, lalu menyimpannya dengan aman di dalam menu AI Chatbot.",
                  userBantuanController.geminiApiKey.value,
                  userBantuanController.toggleGeminiApiKey,
                ),
              ),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }

  Widget helpContainer(
    String title,
    String subtitle,
    bool isToggle,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorDouce.douceBase,
          width: 1.2,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    isToggle ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 28,
                    color: ColorDouce.douceBase,
                  ),
                ],
              ),
            ),
          ),
          if (isToggle) ...[
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontFamily: 'OpenSans',
                  height: 1.5,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
