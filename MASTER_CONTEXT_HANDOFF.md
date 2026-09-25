# MASTER CONTEXT & HANDOFF DOKUMENTASI SISTEM MOMSIE
> **Dokumen ini dirancang sebagai Single Source of Truth (SSOT)** agar AI atau developer baru dapat langsung memahami seluruh konteks aplikasi Momsie tanpa perlu bertanya dari nol.

---

## 1. Ringkasan Eksekutif Proyek
- **Nama Aplikasi**: Momsie (Platform Kesehatan Ibu Hamil & Pemesanan Doula)
- **Tujuan**: Ekosistem pendampingan kehamilan komprehensif yang menghubungkan ibu hamil (User) dengan tenaga profesional (Mitra Doula & Bidan), dilengkapi edukasi kehamilan mingguan, pelacak ukuran janin, konsultasi AI, serta direktori Rumah Sakit & Toko Bayi.
- **Konteks Program**: P2MW (Program Pembinaan Mahasiswa Wirausaha) 2026.
- **Lokasi Kode Utama**: `d:/p2mw/app/mobile`
- **Status Testing**: 49/49 unit test PASS (`flutter test`).

---

## 2. Tech Stack & Ekosistem
- **Framework**: Flutter (`3.35.3`, Dart `3.9.2`)
- **State Management & Navigasi**: GetX (`get: ^4.6.6`)
- **Backend / Database**: Firebase (Firebase Auth, Cloud Firestore, Cloud Storage, Analytics)
- **Database Collections Utama**:
  - `user`: Data profil pengguna umum dan mitra (`isDoula`, `role`, `mitraPendingApproval`)
  - `mitra`: Data profil profesional Doula (nama, sertifikasi, biografi, rating, foto, kota/provinsi)
  - `program`: Data kurikulum program yoga/edukasi
  - `materi_access`: Hak akses materi on-demand berbayar (`materi_online`, `paket_bundling`)
  - `config/app_settings`: Feature flags Google Play review (`showPaymentFlow`, `showBookingFlow`)
- **Styling & Design System**:
  - Font: `Poppins` (`AppTypography`)
  - Warna Utama: `ColorDouce.douceBase` (`#FF6B81` / pink maternal)
  - Design Tokens: `lib/shared/theme/design_system.dart` (`AppSpacing`, `AppRadius`, `AppElevation`, `AppSemanticColors`)

---

## 3. Kredensial Login & Akun Pengujian (PENTING)

### A. Demo Cepat (Instant Bypass - Password Bebas)
*Langsung masuk ke dashboard tanpa perlu koneksi Firebase Auth:*
- **User / Ibu Hamil**: `test@momsie.id` atau `ibu.hamil@momsie.id` (Password: bebas, misal `123456`)
- **Mitra Doula**: `dewi.doula@momsie.id`, `laily.doula@momsie.id`, atau `anastasia.doula@momsie.id` (Password: bebas)

### B. Akun Google Play Tester (Firebase Auth)
- **Email**: `tester@momsie.com`
- **Password**: `tester123`

### C. Akun Admin Panel (`/admin-dashboard`)
- **Email**: `admin@momsie.com`
- **Password**: `admin12345` (Memerlukan `role: 'admin'` pada Firestore `user`)

---

## 4. Struktur Arsitektur Direktori (`mobile/lib`)

```text
lib/
├── app/
│   ├── app_routes.dart          # Definisi nama seluruh rute GetX
│   └── app_widget.dart          # Root widget GetMaterialApp & binding global
├── features/
│   ├── login/                   # LoginController & LoginPage
│   ├── register/                # Pendaftaran akun User
│   ├── mitra_register/          # Pendaftaran & verifikasi data diri mitra
│   ├── admin/                   # AdminLogin & AdminDashboard
│   ├── sop/                     # SOP form, waiting, & approval mitra
│   ├── onboarding/              # Onboarding 3 slide & Maternal Context questionnaire
│   ├── pin/                     # Security PIN entry & setup
│   ├── user/                    # MODUL IBU HAMIL (User Role)
│   │   ├── beranda/             # Dashboard, carousel 3D, Size Guide janin, quick actions
│   │   ├── kesehatan/           # Direktori Doula, booking, Rumah Sakit terdekat
│   │   ├── edukasi/             # Program Yoga 9 bulan & Artikel Medis
│   │   ├── eksplor/             # Direktori Toko Bayi, Rumah Sakit, pencarian
│   │   ├── ai_chat/             # Momsie AI Chatbot interaktif
│   │   ├── chat/                # Real-time chat dengan mitra Doula
│   │   ├── pesanan/             # Status pesanan aktif & riwayat transaksi
│   │   └── akun/                # Profil pengguna, riwayat kehamilan, hubungi kami
│   └── mitra/                   # MODUL DOULA (Mitra Role)
│       ├── beranda/             # Dashboard mitra, terima pesanan
│       ├── pekerjaan/           # Status order & tracking layanan
│       ├── pendapatan/          # Penarikan dana & mutasi
│       └── akun/                # Profil mitra, ganti PIN, detail layanan
├── shared/
│   ├── data/
│   │   └── dummy_data.dart      # Master fallback mock data (Doulas, RS, Toko, Artikel, Yoga)
│   ├── theme/
│   │   ├── color.dart           # Palette warna (ColorDouce)
│   │   └── design_system.dart   # Standard spacing, radius, typography, shadow
│   ├── util/
│   │   ├── model/               # Model data Dart (Doula, RS, Program, Pesanan, Toko)
│   │   ├── service/             # Firebase & REST services (DoulaService, ProgramService, Midtrans)
│   │   └── user_controller.dart # Global permanent user state (UID, role, profile)
│   └── widget/                  # Komponen UI umum (BasePage, Navbar, Spotlight/Modal Tour, Containers)
└── main.dart                    # Entry point aplikasi & inisialisasi Firebase
```

---

## 5. Fitur Kritis & Keputusan Desain Terkini

### 1. Urutan Tampilan & Data Doula (Terbaru)
- **Aturan Prioritas Urutan**:
  1. **Dewi Riana** (`dewi_riana.jpg`) adalah posisi #1 (memiliki foto sertifikasi DONA).
  2. **Laily Artha** (`laily_artha.jpg`) posisi #2 (memiliki foto sertifikasi kebidanan & hypnotherapy).
  3. **22 Peserta Baby SPA Batch 8 (Yogyakarta)** tersertifikasi (`Doula Certified`) terdaftar lengkap dengan gelar resmi (`S.Tr.Keb`, `S.Keb`, `A.Md.Keb`, `S.Kep`, `S.Kes (Ft)`), biografi profesional, tanpa emoji, dan tanpa rating.
  4. Mitra doula lainnya.
  5. **Arvin Demas Naryama** diposisikan di paling bawah (#terakhir).
- **Rating Doula**: Doula tidak menggunakan angka rating/skor (rating ditiadakan di `DoulaModel` dan seluruh data `DummyData.doulas`).
- **Enforcement**: Diimplementasikan dengan fungsi `_doulaPriority()` di `user_kesehatan_controller.dart` dan `user_beranda_controller.dart`. Data dari Firestore maupun `DummyData` selalu mematuhi urutan ini.

### 2. Onboarding Feature Tour (`SpotlightTourOverlay`)
- Komponen *spotlight cutout* yang sebelumnya memicu kotak putih polos telah diganti total menjadi **Centered Modal Pop-up Dialog** di `lib/shared/widget/spotlight_tour.dart`.
- Tampil dengan animasi smooth, badge "Panduan Fitur", deskripsi langkah 1-3, dan tombol Kembali/Lanjut/Selesai.
- Key SharedPreferences: `has_seen_spotlight_tour`.

### 3. Program Yoga Hamil & Meditasi
- Terletak di Tab Edukasi (`user_edukasi_page.dart` & `user_detailprogram_page.dart`).
- **Akses**: Bukan materi terkunci! Bebas diakses oleh seluruh user tanpa perlu status langganan.
- **Gambar**: Menggunakan multi-tier fallback cerdas (`_buildProgramImage`), otomatis memakai `assets/images/promo_doula_3_yoga.jpg` jika data dari Firestore tidak menyertakan gambar.
- **Kurikulum**: Dilengkapi data latihan lengkap 9 bulan (tiap bulan berisi 4 minggu dan panduan gerakan berwaktu) dari `ProgramService`.

### 4. Smart Merge & Local Asset Resolution (Fix #23)
- Modul Rumah Sakit, Toko Bayi, dan Doula menggunakan prinsip *Smart Merge*: Data dummy lokal digabungkan dengan dokumen baru Firestore berdasarkan deduplikasi nama case-insensitive.
- Gambar network Unsplash memiliki fallback otomatis ke aset gambar lokal di folder `assets/images/`.

### 5. Google Play Review Readiness & Feature Flags
- Fitur bypass pembayaran OVO dan booking diatur via Firestore dokumen `config/app_settings`:
  - `showPaymentFlow`: `false` saat masa review Google Play, `true` saat live.
  - `showBookingFlow`: `false` saat masa review, `true` saat live.
- File konfigurasi bacaan: `lib/shared/util/service/app_config_service.dart`.

---

## 6. Perintah Operasional & Debugging

```powershell
# 1. Masuk ke folder proyek Flutter
cd d:\p2mw\app\mobile

# 2. Menjalankan Unit & Widget Test (Wajib lulus 49/49)
flutter test

# 3. Menjalankan di Chrome (Web Development)
flutter run -d chrome

# 4. Melakukan Hot Restart saat app berjalan
# Di terminal flutter run: tekan tombol 'R' (kapital)
# Atau via reload browser: Ctrl + F5

# 5. Build Release Android App Bundle (AAB) untuk Google Play
$env:GRADLE_USER_HOME="D:\.gradle"
flutter build appbundle --release
```
