# HANDOVER & CONTEXT GUIDE — MOMSIE MOBILE APP (P2MW 2026)

Dokumen ini adalah **panduan konteks lengkap (handover prompt)** untuk membuka, menjalankan, dan melanjutkan pengembangan platform **Momsie** di perangkat MacBook / macOS maupun sesi AI baru.

---

## 1. RINGKASAN EKSEKUTIF PROYEK

* **Nama Platform:** Momsie (sebelumnya Douce)
* **Kategori Usaha:** Startup Layanan Kesehatan Digital Maternal & Edukasi Persalinan (Program Pembinaan Mahasiswa Wirausaha / P2MW 2026 Kemendikbudristek)
* **Fitur Utama:**
  1. **Booking & Layanan Doula / Bidan Mandiri:** Pendampingan persalinan offline/online, kelas prenatal yoga, materi edukasi kehamilan, dan bundling.
  2. **Atomic Slot Reservation:** Sistem jadwal dinamis dengan guard kapasitas (*bookedCount* vs *capacity*) menggunakan atomic transaction Firestore.
  3. **Payment Gateway Midtrans Snap Production:** Pembayaran otomatis multi-metode (QRIS, GoPay, ShopeePay, Virtual Account BCA/Mandiri/BNI/BRI).
  4. **Konsultasi Chat Real-time:** Fitur chat terenkripsi antara Bunda (User) dan Doula/Bidan (Mitra) dengan reply quote & push notification.
  5. **Toko Bayi & Rumah Sakit Rujukan:** Direktori faskes dan kebutuhan ibu hamil terdekat.
  6. **Akses Mitra (Doula):** Dashboard pekerjaan, kalender atur jadwal slot, dan rincian bagi hasil (*revenue share split*).

---

## 2. SPESIFIKASI TEKNIS & ARSITEKTUR

* **Framework:** Flutter (Channel stable, Android SDK 34, iOS Deployment Target 14.0+)
* **State Management:** GetX (Reactive State, GetControllers, GetX Route Navigation)
* **Backend:** Google Firebase
  * **Firebase Authentication:** Login Email/Password, Biometric PIN (6 digit)
  * **Cloud Firestore:** Database realtime (`users`, `bookings`, `transactions`, `booking_slots`, `chats`, `materi_access`)
* **Payment Gateway:** Midtrans Snap API (Production Environment)
* **Git Repository:** `https://github.com/ArvinDemas/momsie-app.git`
* **Active Working Branch:** `mitra-sop-fix_1788364556`

---

## 3. STATUS KREDENSIAL & LINGKUNGAN AKTIF

### A. Midtrans Production (Aktif di `lib/shared/util/service/midtrans_service.dart`)
* **Environment:** `Production` (`isProduction = true`)
* **Merchant ID:** `M885831496`
* **Client Key:** `Mid-client-RHPQ7TdYOfAqyY49`
* **Server Key:** Terkonfigurasi aman di `lib/shared/util/service/midtrans_service.dart` (Production)
* **Snap API URL:** `https://app.midtrans.com/snap/v1/transactions`
* **Status API URL:** `https://api.midtrans.com/v2`

### B. Isolasi Akun Demo vs Real User (Siap Rilis Play Store)
Untuk keperluan presentasi/video demo juri P2MW, terdapat akun demo khusus yang **diisolasi total** agar tidak bocor ke pengguna umum di Play Store:
* **User Demo:** `adnaryama1@gmail.com`
  * Otomatis terhubung dengan mock history pesanan Doula Dewi dan pesan chat simulasi konsultasi.
* **Mitra Demo:** `anastasia@momsie.id` (UID: `doula_anastasia`)
  * Otomatis terhubung dengan simulasi pesanan masuk dan histori pendapatan mitra.
* **Pengguna Riil (Play Store):** Hanya melihat data mereka sendiri (`userId == uid`).

---

## 4. UPDATE PROGRESS TERBARU & BUG FIXES SELESAI

1. **Perbaikan Notifikasi "Gagal Slot Penuh" (Payment Flow):**
   * *Akar Masalah:* Dokumen slot Firestore belum ada untuk tanggal yang dipilih (`!snapshot.exists`) dan data legacy bertipe String menyebabkan exception, serta tombol bayar ulang di Pesanan mencoba double-reserve slot.
   * *Solusi:* Auto-inisialisasi dokumen slot default di `booking_slot_service.dart`, defensive parsing (Map & String), smart re-payment di `payment_service.dart` (jika `booking.id.isNotEmpty`, skip increment), dan auto-rollback slot jika Snap token gagal dibuat.
2. **Kredensial Midtrans Production Diterapkan:**
   * Diperbarui dari mode sandbox/kosong ke mode Production live dengan kredensial Merchant ID `M885831496`.
3. **Perbaikan Header & Avatar Chat Doula:**
   * Header chat tidak lagi melompat ke nama/foto user sendiri, melainkan konsisten menampilkan profil Doula tujuan dari `DummyData.doulas`.
   * Penanganan defensive pada field `replyQuote` di `chat_controller.dart`.
4. **Dokumen Legal & Pembelaan Juri P2MW:**
   * Dibuatkan berkas kepatuhan regulasi UU No. 27 Tahun 2022 (UU PDP), Peraturan Bank Indonesia No. 23/6/PBI/2021, Kebijakan Privasi Midtrans, dan Legal Compliance Brief di folder `docs/legal/`.
5. **Kualitas Pengujian:**
   * **51/51 Unit Tests PASS (100% Berhasil)** tanpa error.
   * `flutter analyze` 0 error.

---

## 5. STRUKTUR DIREKTORI PENTING

```
lib/
├── features/
│   ├── auth/                      # Login, Register, Forgot Password
│   ├── pin/                       # Setup & Entry PIN 6-digit (Biometric Fallback)
│   ├── mitra/                     # Halaman Khusus Doula (Pekerjaan, Jadwal, Pendapatan)
│   │   ├── profil/                # Atur jadwal slot mitra (mitra_aturjadwal_controller.dart)
│   │   ├── pekerjaan/             # Manajemen pesanan masuk (mitra_pekerjaan_controller.dart)
│   │   └── pendapatan/            # Rekap keuangan mitra (mitra_pendapatan_controller.dart)
│   └── user/                      # Halaman Khusus Bunda / Pengguna
│       ├── kesehatan/             # Booking Doula & Confirm Booking
│       │   ├── booking_doula_controller.dart
│       │   ├── booking_doula_page.dart
│       │   └── confirm_booking_page.dart
│       ├── pesanan/               # Riwayat Pesanan & Detail Pesanan
│       │   ├── user_pesanan_controller.dart
│       │   ├── user_pesanan_page.dart
│       │   └── booking_detail_page.dart
│       └── chat/                  # Chat Room Realtime User - Doula
│           ├── chat_controller.dart
│           └── chat_page.dart
├── shared/
│   ├── util/
│   │   ├── model/                 # BookingModel, TransaksiModel, BookingSlotModel
│   │   └── service/               # MidtransService, PaymentService, BookingSlotService
│   └── widget/                    # PaymentSheet, PaywallModal, BottomSheet
docs/
└── legal/                         # Dokumen Resmi UU PDP, PBI, Midtrans, dan Legal Notice PDF
```

---

## 6. CARA SETUP & MENJALANKAN DI MACBOOK (MACOS)

Buka Terminal di MacBook:

```bash
# 1. Clone repository (jika belum di-clone)
git clone https://github.com/ArvinDemas/momsie-app.git
cd momsie-app

# 2. Checkout ke branch aktif
git checkout mitra-sop-fix_1788364556
git pull origin mitra-sop-fix_1788364556

# 3. Install dependency Flutter
flutter pub get

# 4. Install Pods untuk iOS (khusus macOS)
cd ios
pod install
cd ..

# 5. Jalankan Unit Test (Pastikan 51/51 Passed)
flutter test

# 6. Jalankan di Simulator iPhone atau Perangkat Android
flutter run
```

---

## 7. PROMPT SIAP COPY-PASTE UNTUK SESI AI DI MACBOOK

*Salin teks di bawah ini dan tempelkan langsung ke Claude / ChatGPT / Antigravity di MacBook:*

```text
Halo! Saya sedang melanjutkan pengembangan proyek aplikasi "Momsie" (sebelumnya Douce), sebuah platform startup kesehatan digital maternal & booking Doula/Bidan untuk Program P2MW 2026.

Berikut konteks teknis dan status proyek saat ini:
1. Repository: https://github.com/ArvinDemas/momsie-app.git
2. Branch aktif: mitra-sop-fix_1788364556
3. Tech Stack: Flutter (GetX), Firebase (Auth & Firestore), Midtrans Snap Payment Gateway.
4. Midtrans: Sudah dikonfigurasi aktif di mode PRODUCTION (Merchant ID: M885831496, Client Key: Mid-client-RHPQ7TdYOfAqyY49, Server Key Production aktif).
5. Akun Demo Khusus: 'adnaryama1@gmail.com' (User) dan 'anastasia@momsie.id' (Mitra Doula). Semua akun demo telah diisolasi ketat agar tidak mengganggu pengguna Play Store.
6. Progress Terakhir:
   - Memperbaiki bug pembayaran 'gagal slot penuh' pada reservasi slot doula (auto-inisialisasi dokumen slot, defensive parsing String/Map, dan pencegahan double-increment pada pesanan pending).
   - Memperbaiki header chat doula agar tidak melompat ke nama pengguna sendiri.
   - Mengintegrasikan dokumen legal compliance (UU PDP No. 27/2022, PBI No. 23/6/2021, dan Midtrans ToS) di docs/legal/.
   - Semua 51 unit test telah berstatus PASS.
7. Dokumen konteks lengkap tersedia di HANDOVER_CONTEXT_MACBOOK.md.

Tolong bantu saya melanjutkan pekerjaan selanjutnya dengan memahami konteks arsitektur di atas.
```
