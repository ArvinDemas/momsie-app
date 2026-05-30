# Douce (Doula Booking & Maternal Health Platform)

## Deskripsi Aplikasi
Douce (direferensikan juga sebagai Doula App) adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk menghubungkan ibu hamil (User) dengan tenaga profesional Doula dan mitra kesehatan (Mitra). Aplikasi ini menyediakan ekosistem terpadu untuk pemantauan kehamilan, konsultasi online, pemesanan layanan doula, pembelian obat, serta edukasi kesehatan ibu dan anak.

## Teknologi Utama
- **Framework**: Flutter (`>=3.3.1 <4.0.0`)
- **State Management & Navigasi**: GetX (`get: ^4.6.6`)
- **Backend / Database**: Firebase (Auth, Cloud Firestore, Cloud Storage, Core)
- **Lokasi & Pemetaan**: Google Maps (`google_maps_flutter`), Geolocator
- **Autentikasi**: Firebase Auth, Google Sign-In
- **Utilitas Tambahan**: `image_picker`, `http`, `intl`

## Arsitektur & Fitur Utama

Aplikasi ini menggunakan arsitektur *Role-Based* yang membagi fungsionalitas menjadi dua bagian besar:

### 1. User (Ibu Hamil / Pasien)
Terletak di `lib/features/user/`, modul ini khusus untuk pengguna umum.
- **Beranda & Edukasi**: Dashboard utama untuk memantau progres kehamilan, membaca artikel kesehatan (`user-artikel`), dan mengikuti program mingguan/bulanan (`user-program`).
- **Kesehatan**: Fitur pemantauan kesehatan detail termasuk riwayat dan pergerakan bayi (`user-detail-gerakan`).
- **Pencarian & Booking**: Fitur untuk mencari Doula atau Rumah Sakit terdekat berdasarkan lokasi geolokasi (`detail-doula`, `booking-doula`, `detail-rumah-sakit`).
- **Obat & Pesanan**: Layanan pemesanan obat (`detail-obat`) dan pelacakan pesanan jasa doula atau produk (`user-pesanan`).
- **Chat**: Komunikasi real-time dengan mitra doula (`chat-page`).
- **Akun**: Pengaturan profil, bahasa, notifikasi, dan privasi.

### 2. Mitra (Maternal Partner / Doula / Toko Obat)
Terletak di `lib/features/mitra/`, modul ini dirancang bagi tenaga profesional.
- **Mitra Registration**: Alur pendaftaran khusus untuk memvalidasi profesionalitas Mitra (`mitra-register`, `mitra-data-diri`).
- **Beranda & Pekerjaan**: Dashboard untuk melihat status order, menerima/menolak pesanan, dan mengatur layanan.
- **Pendapatan**: Fitur pencatatan dan penarikan hasil pendapatan aplikasi (`mitra-pendapatan`).
- **Manajemen Toko**: Pengaturan untuk mitra yang memiliki layanan apotek/obat (`detail-toko`).

## Struktur Folder (Architecture Directory)
```text
lib/
 ├── app/               # Konfigurasi inti dan routing aplikasi (app_routes.dart, app_widget.dart)
 ├── features/          # Kumpulan fitur utama aplikasi yang dipisahkan berdasarkan domain
 │    ├── login/        # Autentikasi Pengguna
 │    ├── register/     # Pendaftaran User Umum
 │    ├── mitra_register# Pendaftaran khusus untuk Mitra
 │    ├── splash/       # Splash screen awal
 │    ├── user/         # Komponen dan tampilan untuk modul Ibu Hamil
 │    └── mitra/        # Komponen dan tampilan untuk modul Doula/Partner
 ├── shared/            # Komponen-komponen umum (Widget, Tema, Util controller)
 └── main.dart          # Entry point utama aplikasi
```

## Panduan Instalasi & Menjalankan Aplikasi

1. **Pastikan Environment Siap**
   * Flutter SDK (`>=3.3.1`) telah terpasang.
   * Android Studio / VS Code siap pakai.
   
2. **Pemasangan Dependencies**
   Buka terminal di root project dan jalankan:
   ```bash
   flutter pub get
   ```

3. **Konfigurasi Firebase**
   Proyek ini menggunakan Firebase. Pastikan file konfigurasi platform (cth: `google-services.json` untuk Android atau `GoogleService-Info.plist` untuk iOS) telah tersedia di direktori yang tepat sesuai setelan `firebase_options.dart`.

4. **Kompilasi dan Run**
   ```bash
   flutter run
   ```

---
*Dokumentasi ini di-generate berdasarkan struktur `pubspec.yaml`, `app_routes.dart`, dan arsitektur direktori `lib/`.*
