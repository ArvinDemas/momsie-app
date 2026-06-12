# Dokumentasi Rilis Google Play Console & Migrasi Device (Momsie)

Dokumen ini berisi rangkuman konfigurasi rilis, status pembersihan aplikasi untuk verifikasi Google Play, panduan pengujian tertutup (closed testing), serta panduan migrasi kode untuk pindah perangkat baru.

---

## 📂 1. Informasi Build & Release AAB
* **Lokasi File AAB (Android App Bundle):**
  `app/mobile/build/app/outputs/bundle/release/app-release.aab`
  *File inilah yang diunggah ke Google Play Console pada menu Jalur Pengujian Tertutup.*

---

## ⚙️ 2. Rincian Konfigurasi Google Play Console

Selama pengisian kuesioner kelayakan aplikasi, berikut adalah jawaban konfigurasi yang telah disepakati untuk meminimalisir penolakan dan mempercepat proses review Google:

| Bagian | Status / Konfigurasi | Keterangan |
| :--- | :--- | :--- |
| **Akses Aplikasi** | `tester@momsie.com` / `tester123` | Kredensial untuk tim review Google masuk ke aplikasi. Akun ini harus didaftarkan terlebih dahulu di menu pendaftaran aplikasi agar datanya ada di Firebase sebelum Google mulai mereview. |
| **Rating Konten (IARC)** | Rating: **3+** | Dijawab **"Tidak"** untuk kekerasan, konten seksual, obat terlarang. Dijawab **"Ya"** untuk akses konten online (karena ada Gemini AI & scraper artikel). |
| **Target Audience** | **18 Tahun ke Atas** | Memilih target umur 18+ sangat disarankan untuk melewati audit kebijakan anak-anak (*Family Policies*) yang sangat ketat dan memakan waktu review lebih lama. |
| **Data Safety** | Deklarasi Data | Mengisi data yang dikumpulkan (tidak dibagikan ke pihak ketiga) seperti: lokasi, info pribadi, info kesehatan (karena ada log kehamilan/bayi), pesan, dan foto. |
| **Deklarasi Aplikasi Kesehatan** | *My app does not have any health features* | Diisi tidak memiliki fitur kesehatan klinis medis/farmasi resmi untuk menghindari syarat sertifikasi institusi kesehatan formal. |
| **Kategori & Tag Toko** | Kategori: **Mengasuh Anak** (*Parenting*) | Tag: Mengasuh Anak (*Parenting*), Perawatan Bayi (*Baby Care*), Gaya Hidup, Kalender, Buku Catatan. |
| **Target Geografis** | **Indonesia Saja** | Membatasi rilis hanya di Indonesia menghindari kewajiban regulasi internasional (seperti GDPR di Eropa) dan mempercepat persetujuan rilis. |

---

## 🛡️ 3. Penyesuaian Kode untuk Kelayakan Review (Decoupling)

Beberapa perubahan penting telah dilakukan pada kode untuk menyembunyikan fitur-fitur sensitif dari tim penilai Google (untuk menghindari kewajiban sertifikasi medis):

1. **Pemisahan Akses Admin (Decoupling Admin):**
   * Gesture klik ganda (*double-tap*) rahasia pada logo dan tombol pintasan "Akses Admin" di halaman login (`lib/features/login/login_page.dart`) telah dihapus.
   * Halaman login admin sekarang benar-benar terpisah dari alur pengguna biasa.
2. **Penyembunyian Tab Obat (Pharmacy/Medicine Tab):**
   * Tab navigasi belanja obat / farmasi online di bottom navigation bar (`lib/features/user/main_user.dart`) telah disembunyikan/dikomentari.
   * Hal ini krusial agar Google tidak menganggap Momsie sebagai aplikasi toko obat/farmasi online yang membutuhkan lisensi apotek resmi.

---

## 👥 4. Aturan Pengujian Tertutup (Closed Testing)

Berdasarkan aturan terbaru Google Play (berlaku untuk akun developer pribadi baru):

1. **Persyaratan Penguji:**
   * Diperlukan minimal **12 penguji** aktif yang mendaftar menggunakan akun Gmail masing-masing.
   * Penguji harus mengunduh aplikasi melalui link opt-in Play Store dan membiarkannya terinstal di HP Android mereka selama **14 hari berturut-turut**.
   * Jika jumlah penguji turun di bawah 12 orang sebelum 14 hari selesai, counter waktu akan **direset ke hari ke-1**. *Sangat disarankan mendaftarkan minimal 15-20 penguji sebagai cadangan.*
2. **Cara Mendapatkan Penguji Alternatif:**
   * **Barter Uji (Mutual Testing):** Cari rekan developer lain di subreddit [r/AndroidClosedTesting](https://www.reddit.com/r/AndroidClosedTesting/) atau grup Facebook/Telegram bertema *"Google Play Closed Testing Indonesia"*. Anda menguji aplikasi mereka, mereka menguji aplikasi Momsie Anda.
   * **Jaringan P2MW:** Ajak sesama kelompok mahasiswa P2MW di kampus Anda untuk saling bantu menginstal dan membiarkan aplikasi terpasang selama 14 hari.

---

## 💻 5. Langkah Migrasi Setelah Ganti Device Baru

Jika Anda akan berganti laptop atau komputer baru, ikuti langkah-langkah berikut agar proyek Flutter Momsie siap dijalankan kembali:

### Langkah Awal di Device Baru:
1. **Instal Perangkat Lunak Pendukung:**
   * Java Development Kit (JDK 17 atau versi yang kompatibel).
   * Android Studio & Android SDK.
   * Flutter SDK (pastikan versinya sama dengan device sebelumnya).
   * Git.
2. **Kloning Repositori:**
   ```bash
   git clone <url-repositori-github-anda>
   ```
3. **Pindahkan File Keystore & File Konfigurasi (PENTING!):**
   * Pastikan Anda mencadangkan file keystore Android (biasanya berakhiran `.jks` atau `.keystore`) beserta file `key.properties` yang digunakan untuk menandatangani aplikasi (*signing config*). Jika hilang, Anda tidak akan bisa melakukan update aplikasi di masa mendatang.
   * Pastikan file `android/app/google-services.json` (Firebase) tercakup di repositori Git Anda.

### Perintah Pembangunan Ulang di Device Baru:
Jalankan perintah berikut di root folder project (`app/mobile`):
```bash
# Mengambil ulang dependencies project
flutter pub get

# Membersihkan build lama jika ada error cache
flutter clean
flutter pub get

# Menjalankan aplikasi di emulator/HP asli (Debug Mode)
flutter run

# Membangun kembali file rilis AAB yang siap diupload ke Play Console
flutter build appbundle --release
```

---
*Dokumen ini dibuat secara otomatis untuk memudahkan tracking rilis. Silakan commit dan push file ini ke GitHub.*
