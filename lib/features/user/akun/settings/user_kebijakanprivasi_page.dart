import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserKebijakanPrivasiPage extends StatelessWidget {
  const UserKebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
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
                    "Kebijakan Privasi",
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: const [
                    Text(
                      "Terakhir diperbarui: 31 Mei 2026",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    SizedBox(height: 20),
                    _SectionTitle("1. Informasi yang Kami Kumpulkan"),
                    _SectionBody(
                      "Momsie mengumpulkan informasi berikut saat Anda menggunakan aplikasi:\n\n"
                      "• Informasi Akun: nama pengguna, alamat email, dan foto profil.\n"
                      "• Data Kesehatan: informasi terkait kehamilan dan riwayat program kesehatan yang Anda ikuti di dalam aplikasi.\n"
                      "• Data Lokasi: lokasi perangkat Anda (hanya saat aplikasi aktif di layar) untuk menampilkan rumah sakit dan tenaga kesehatan terdekat.\n"
                      "• Data Penggunaan: halaman yang dikunjungi dan fitur yang digunakan di dalam aplikasi.\n"
                      "• Data Komunikasi: pesan yang dikirim melalui fitur chat dengan tenaga kesehatan (Doula).",
                    ),
                    SizedBox(height: 16),
                    _SectionTitle("2. Bagaimana Kami Menggunakan Informasi Anda"),
                    _SectionBody(
                      "Informasi yang kami kumpulkan digunakan untuk:\n\n"
                      "• Menyediakan dan meningkatkan layanan aplikasi.\n"
                      "• Menampilkan rekomendasi konten kesehatan yang relevan.\n"
                      "• Menghubungkan Anda dengan tenaga kesehatan (Doula) terdekat.\n"
                      "• Mengelola akun dan autentikasi pengguna.\n"
                      "• Mengirimkan notifikasi dan pembaruan layanan.",
                    ),
                    SizedBox(height: 16),
                    _SectionTitle("3. Penyimpanan dan Keamanan Data"),
                    _SectionBody(
                      "Data Anda disimpan di server Google Firebase yang berlokasi di infrastruktur cloud aman. Kami menerapkan enkripsi dan langkah-langkah keamanan standar industri untuk melindungi data Anda dari akses, perubahan, atau pengungkapan yang tidak sah.",
                    ),
                    SizedBox(height: 16),
                    _SectionTitle("4. Berbagi Data dengan Pihak Ketiga"),
                    _SectionBody(
                      "Kami tidak menjual atau menyewakan data pribadi Anda kepada pihak ketiga. Data Anda hanya dapat dibagikan kepada:\n\n"
                      "• Tenaga kesehatan (Doula) yang Anda pilih untuk berkonsultasi, atas persetujuan Anda.\n"
                      "• Penyedia layanan teknis (seperti Firebase oleh Google) sebagai bagian dari infrastruktur aplikasi.",
                    ),
                    SizedBox(height: 16),
                    _SectionTitle("5. Data Lokasi"),
                    _SectionBody(
                      "Kami hanya mengakses lokasi perangkat Anda saat aplikasi aktif dan terbuka di layar (foreground). Kami tidak melacak lokasi Anda di latar belakang. Data lokasi digunakan semata-mata untuk menampilkan fasilitas kesehatan terdekat.",
                    ),
                    SizedBox(height: 16),
                    _SectionTitle("6. Hak Pengguna"),
                    _SectionBody(
                      "Anda memiliki hak untuk:\n\n"
                      "• Mengakses data pribadi yang kami simpan tentang Anda.\n"
                      "• Meminta koreksi data yang tidak akurat.\n"
                      "• Meminta penghapusan akun dan data Anda.\n"
                      "• Menarik persetujuan penggunaan data kapan saja.\n\n"
                      "Untuk mengajukan permintaan tersebut, silakan hubungi kami melalui menu Bantuan di dalam aplikasi.",
                    ),
                    SizedBox(height: 16),
                    _SectionTitle("7. Retensi Data"),
                    _SectionBody(
                      "Kami menyimpan data Anda selama akun Anda aktif atau selama diperlukan untuk menyediakan layanan. Setelah penghapusan akun, data akan dihapus dari sistem kami dalam waktu 30 hari.",
                    ),
                    SizedBox(height: 16),
                    _SectionTitle("8. Perubahan Kebijakan Privasi"),
                    _SectionBody(
                      "Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Perubahan signifikan akan diberitahukan melalui notifikasi di dalam aplikasi. Penggunaan berkelanjutan atas layanan kami setelah perubahan berlaku dianggap sebagai persetujuan Anda.",
                    ),
                    SizedBox(height: 16),
                    _SectionTitle("9. Hubungi Kami"),
                    _SectionBody(
                      "Jika Anda memiliki pertanyaan mengenai kebijakan privasi ini, silakan hubungi kami melalui fitur Bantuan di menu Pengaturan aplikasi.",
                    ),
                    SizedBox(height: 30),
                  ],
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
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  final String text;
  const _SectionBody(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
        fontFamily: 'OpenSans',
        height: 1.6,
      ),
    );
  }
}
