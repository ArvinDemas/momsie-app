# Requirements — Modul Transaksi, Pembayaran & Layanan Doula (Momsie)
**Status: FINAL — 100% Watertight**
**Last Updated: 2026-09-12**

## 1. Context

Modul ini merancang alur transaksi end-to-end untuk 5 kategori layanan Momsie:
- **Chat Doula** (konsultasi online via chat, Rp 30.000) — **wajib slot jadwal**, auto-confirmed saat paid
- **Online Edukasi / Materi Prenatal** (Rp 99.000) — **on-demand** (tanpa slot), akses materi selamanya setelah paid
- **Online Yoga / Prenatal Yoga** (Rp 75.000) — **wajib slot jadwal Live Zoom**, auto-confirmed saat paid
- **Online Bundling** (paket gabungan edukasi + yoga, Rp 135.000) — **on-demand**, akses materi selamanya setelah paid
- **Pendampingan Offline / Full Journey** (Rp 3.000.000) — **wajib slot jadwal**, konfirmasi manual opsional

Codebase:
- Mobile client: `D:\p2mw\app\mobile` (Flutter, Firebase Firestore, GetX)
- Admin web dashboard: `D:\p2mw\momsie` (Next.js static export, Firebase Firestore, Tailwind CSS)

Asumsi bisnis yang disepakati:
- **Split komisi**: 15% platform fee, 85% hak doula (sumber: `PaymentService.calculateSplit`).
- **Biaya admin platform**: Rp 2.000 per transaksi.
- **Pembayaran 100% otomatis via Midtrans Snap** — tidak ada transfer manual, tidak ada upload bukti, tidak ada status `pending_review`.
- **Chat Doula, Online Yoga memiliki jadwal kaku dengan kuota dinamis** — doula menentukan capacity per slot jam; booking penuh saat booked_count == capacity.
- **Online Edukasi (materi mandiri) dan Online Bundling bersifat on-demand** — tanpa pemilihan jam slot; akses modul terbuka selamanya setelah paid.
- **Customer memilih doula sendiri** — tidak ada penugasan oleh admin untuk layanan Offline.
- **Auto-confirmation**: Layanan Chat, Yoga, Edukasi → otomatis `confirmed` saat webhook `settlement`. Layanan Offline → konfirmasi manual opsional oleh doula/admin.
- **Fallback WhatsApp**: Jika zoomLink belum diinput admin, tampilkan tombol "Hubungi Admin via WhatsApp" sebagai fallback.

---

## 2. User Stories

### US-1: Membuat Pesanan (Booking Flow)
Sebagai pengguna ibu hamil, saya ingin memilih doula, jadwal (jika applicable), dan jenis layanan sehingga saya bisa memesan layanan pendampingan.

**Acceptance Criteria:**
- [ ] User memilih doula dari katalog (`detail_doula_page.dart`).
- [ ] **Untuk layanan dengan jadwal wajib** (Chat Doula, Online Yoga, Offline): user memilih tanggal (view bulanan & mingguan) dan jam (slot tersedia).
- [ ] **Untuk layanan on-demand** (Edukasi Mandiri, Bundling): user TIDAK diminta memilih slot jam — langsung ke ringkasan pesanan.
- [ ] User memilih jenis layanan dari 5 opsi dengan harga masing-masing.
- [ ] Untuk layanan Offline (Full Journey), user wajib mengisi alamat.
- [ ] Tombol "Lanjutkan ke Konfirmasi" aktif hanya bila semua field wajib terisi.
- [ ] Slot yang sudah `FULL` (booked_count >= capacity) ditampilkan non-aktif (disabled).
- [ ] Doula dapat mengatur kapasitas per slot jam melalui dashboard mitra atau form di profil.

### US-2: Konfirmasi & Pembayaran (Midtrans Snap Only)
Sebagai pengguna, saya ingin melihat rincian pesanan + melakukan pembayaran otomatis via Midtrans Snap sehingga transaksi tercatat aman.

**Acceptance Criteria:**
- [ ] Halaman konfirmasi menampilkan ringkasan: doula, jadwal (jika applicable), layanan, rincian harga (harga layanan + biaya admin Rp 2.000 = total bayar).
- [ ] Countdown timer 15 menit tampil di halaman konfirmasi; auto-expire ke status `expired` bila waktu habis.
- [ ] PIN/biometrik authentication wajib sebelum membuka sheet pembayaran.
- [ ] Hanya tersedia satu metode pembayaran: **Midtrans Snap** (QRIS, VA, E-Wallet, Kartu Kredit).
- [ ] Status transaksi di Firestore dibuat `pending` segera setelah Snap token dibuat.
- [ ] Tidak ada opsi transfer manual atau upload bukti pembayaran.

### US-3: Pembayaran Otomatis via Midtrans Snap + Webhook
Sebagai sistem, pembayaran harus tereksekusi sepenuhnya otomatis tanpa intervensi manual admin.

**Acceptance Criteria:**
- [ ] Firebase Cloud Functions (`createMidtransSnap`) membuat Snap token server-side menggunakan server key yang tersimpan aman.
- [ ] Flutter app membuka halaman pembayaran Midtrans via browser/WebView menggunakan redirect URL.
- [ ] App melakukan polling status Midtrans (maks 3 menit / 18 polling × 10 detik) sebagai fallback.
- [ ] Webhook Midtrans (`/api/webhooks/midtrans`) menerima callback `settlement`/`capture` dan mengupdate Firestore ke `paid` secara real-time.
- [ ] Idempotency check di webhook: transaksi dengan transactionId yang sama tidak diproses dua kali.
- [ ] Jika polling timeout dan webhook belum sampai, transaksi tetap berstatus `pending` hingga webhook tiba.
- [ ] Timer countdown 15 menit: jika transaksi belum `paid`, Cloud Function trigger auto-expire.

### US-4: Distribusi Link Zoom & Fallback WhatsApp untuk Layanan Online
Sebagai pengguna layanan Online (Yoga, Edukasi, Bundling), saya ingin menerima link Zoom setelah pembayaran dikonfirmasi.

**Acceptance Criteria:**
- [ ] Link Zoom tersedia di halaman detail pesanan setelah status booking = `paid` atau `confirmed`.
- [ ] Link dapat disalin (copy-to-clipboard) dan dibuka langsung di browser.
- [ ] Link hanya muncul untuk layanan online (Edukasi, Yoga, Bundling); tidak ditampilkan untuk Chat Doula atau Offline.
- [ ] Admin dapat mengatur link Zoom per jadwal kelas di dashboard React (`d:\p2mw\momsie`).
- [ ] Link Zoom disimpan di Firestore koleksi `zoom_links`.
- [ ] Doula dapat mengelola link Zoom miliknya via dashboard mitra.
- [ ] **Fallback WhatsApp**: Jika status `paid/confirmed` tetapi `zoomLink == null`, tampilkan badge *"Menunggu Link Kelas dari Admin"* dan tombol **"Hubungi Admin via WhatsApp"**.
- [ ] Tombol WhatsApp otomatis membuka aplikasi dengan template pesan: `"Halo Admin Momsie, saya sudah membayar [Nama Layanan] (ID: [Order ID]). Mohon info link Zoom-nya ya."`
- [ ] Begitu admin mengisi link di dashboard, badge & tombol otomatis berubah menjadi **"Join Zoom Meeting"**.

### US-5: Chat Doula dengan Jadwal & Kuota Dinamis
Sebagai pengguna layanan Chat Doula, saya ingin memesan slot jadwal chat dengan doula tertentu dan terhubung ke room chat saat slot dimulai.

**Acceptance Criteria:**
- [ ] Chat Doula memiliki durasi (1 jam) dan **wajib memilih slot jadwal waktu**.
- [ ] Setiap slot jam memiliki `capacity` (kuota) yang ditentukan doula (default: 1, dapat diubah doula).
- [ ] Multiple customer dapat booking di slot jam yang sama selama `booked_count < capacity`.
- [ ] Slot hanya disabled jika `booked_count >= capacity`.
- [ ] Room chat aktif dan dapat diakses customer selama durasi slot yang dipesan.
- [ ] Doula menerima notifikasi push saat ada booking baru di slotnya.
- [ ] Customer dapat chat dengan doula dari halaman detail pesanan setelah pembayaran berhasil (`paid` atau `confirmed`).
- [ ] **Auto-confirmed**: Status booking Chat Doula otomatis `confirmed` segera setelah webhook Midtrans `settlement` diterima.

### US-6: Pemilihan Doula Mandiri oleh Customer (Offline & Semua Layanan)
Sebagai pengguna, saya ingin memilih doula sendiri sejak awal sehingga saya merasa memiliki kendali atas pendampingan.

**Acceptance Criteria:**
- [ ] Customer memilih doula dari katalog di `detail_doula_page.dart` sebelum mengisi jadwal.
- [ ] Pemilihan doula berlaku untuk semua 5 jenis layanan (Chat, Online Edukasi, Online Yoga, Bundling, Offline).
- [ ] Setelah pembayaran berhasil (`paid`), booking otomatis terikat pada `doula_id` yang dipilih customer.
- [ ] Doula terpilih menerima notifikasi push bahwa jadwalnya telah dibooking.
- [ ] Peran dashboard admin untuk layanan Offline terbatas pada monitoring ketersediaan & progress, BUKAN menentukan doula.
- [ ] Customer dapat melihat doula yang dipesan di halaman detail pesanan dan riwayat.

### US-7: Status Pesanan di Halaman User
Sebagai pengguna, saya ingin melihat status pesanan secara real-time sehingga saya tahu apa yang harus dilakukan selanjutnya.

**Acceptance Criteria:**
- [ ] Tab "Aktif" menampilkan booking dengan status: pending, paid, confirmed, ongoing.
- [ ] Tab "Riwayat" menampilkan booking dengan status: completed, cancelled, expired.
- [ ] Setiap card menampilkan: layanan, nama doula, tanggal/jam (atau "On-Demand" untuk materi mandiri), nominal, status badge berwarna.
- [ ] Action button sesuai status: "Bayar Sekarang" (pending), "Hubungi Doula" (paid/confirmed/ongoing), "Lihat Bukti Bayar" (paid+).
- [ ] Untuk layanan Online yang sudah `paid/confirmed`: tampilkan link Zoom dengan tombol copy.
- [ ] Untuk layanan Online yang `paid/confirmed` tapi `zoomLink == null`: tampilkan badge *"Menunggu Link Kelas dari Admin"* + tombol **"Hubungi Admin via WhatsApp"**.
- [ ] Untuk layanan Chat yang sudah `paid/confirmed`: tampilkan tombol **"Mulai Chat"** yang mengarahkan ke room chat doula.
- [ ] Untuk layanan On-Demand (Edukasi, Bundling) yang sudah `paid/confirmed`: tampilkan tombol **"Akses Materi"** yang membuka halaman modul.

### US-8: Dashboard Admin — Manajemen Pesanan & Transaksi
Sebagai admin, saya ingin mengelola semua booking & transaksi dari dashboard React sehingga operasional fulfillment rapi.

**Acceptance Criteria:**
- [ ] Tabel transaksi dengan filter: bulan, tahun, range waktu, kategori layanan, status.
- [ ] Tabel booking dengan filter yang sama + pencarian berdasarkan ID, nama user, nama doula.
- [ ] Admin dapat mengubah status booking secara inline (dropdown per baris).
- [ ] KPI: total order, revenue gross, platform fee (15%), doula earnings (85%), pending withdrawal.
- [ ] Grafik pendapatan harian (line chart) & per kategori layanan (bar chart).
- [ ] Nama pelanggan di-mask (initial) dengan toggle mata untuk reveal.
- [ ] Admin dapat mengelola link Zoom per jadwal (CRUD) di halaman khusus.
- [ ] Admin dapat melihat daftar slot booking dengan capacity & booked_count per doula.
- [ ] Halaman withdrawal untuk menyetujui penarikan saldo doula (sudah ada, pertahankan).

### US-9: Mitigasi Error Transaksi
Sistem harus handle kasus gagal bayar, timeout, webhook delay, dan double callback dengan aman.

**Acceptance Criteria:**
- [ ] Transaksi `pending` > 15 menit tanpa pembayaran → auto-expire ke status `expired` (Cloud Function).
- [ ] Double webhook callback diidentifikasi & di-skip via idempotency key (transaction ID).
- [ ] Webhook yang gagal retry maksimal 3x dengan exponential backoff.
- [ ] User mendapat notifikasi jelas saat pembayaran gagal/expired (snackbar + update status card).
- [ ] Status akhir transaksi hanya satu dari: `paid`, `cancelled`, `expired`. Tidak ada status ambigu.
- [ ] Transaksi `expired` membebaskan slot capacity (booked_count dikurangi) agar customer lain bisa booking ulang.

### US-10: Doula Dashboard — Slot Management
Sebagai mitra doula, saya ingin mengatur jadwal, slot, dan kapasitas sehingga saya dapat mengontrol penerimaan customer.

**Acceptance Criteria:**
- [ ] Doula dapat membuat/mengedit slot jam untuk tanggal tertentu di dashboard mitra.
- [ ] Doula dapat mengatur `capacity` (kuota customer per slot) — default 1, max sesuai kebijakan platform.
- [ ] Doula dapat melihat daftar booking masuk per slot beserta statusnya.
- [ ] Doula dapat menghapus slot yang belum ada booking.
- [ ] Status booking doula: pending → paid → confirmed → ongoing → completed/cancelled.

### US-11: Service Booking untuk Layanan On-Demand (Edukasi & Bundling)
Sebagai pengguna layanan on-demand, saya ingin langsung mengakses materi setelah pembayaran berhasil tanpa perlu menunggu slot jadwal.

**Acceptance Criteria:**
- [ ] Layanan Online Edukasi (materi PDF/Video) dan Online Bundling tidak memerlukan pemilihan slot jam.
- [ ] Setelah status `paid`, user langsung mendapat akses ke halaman modul/materi.
- [ ] Akses materi bersifat permanen (unlocked forever) setelah pembayaran berhasil.
- [ ] Tombol **"Akses Materi"** muncul di halaman detail pesanan & tab "Aktif".

---

## 3. Skema Data Model Firestore

### Collection: `transactions`
Field: `id`, `userId`, `namaUser`, `jenisLayanan` ('chat_doula'|'materi_online'|'prenatal_yoga'|'paket_bundling'|'doula_offline'), `deskripsi`, `nominal`, `metodePembayaran` ('midtrans_snap'), `status` ('pending'|'paid'|'cancelled'|'expired'), `buktiPembayaran` (null), `createdAt`, `paidAt`, `expiredAt`, `platformFee`, `doulaEarnings`, `bookingId`, `midtransOrderId`, `midtransStatus`, `idempotencyKey`.

### Collection: `bookings`
Field: `id`, `transactionId`, `userId`, `namaUser`, `doulaUid`, `doulaName`, `doulaPhoto`, `doulaJob`, `tanggal`, `day`, `jam` (nullable untuk on-demand), `layanan`, `alamat` (nullable), `catatan`, `hargaLayanan`, `biayaAdmin`, `totalBayar`, `platformFee`, `doulaEarnings`, `status` ('pending'|'paid'|'confirmed'|'ongoing'|'completed'|'cancelled'|'expired'), `zoomLink` (nullable, untuk layanan online), `isOnDemand` (boolean, true untuk materi_online & paket_bundling), `createdAt`, `paidAt`, `confirmedAt`, `completedAt`, `expiredAt`.

### Collection: `booking_slots` (BARU)
Field: `docId` (composite: `{doulaId}_{tanggal}`), `doulaId`, `tanggal` (YYYY-MM-DD), `slots` (list of objects: `{time, capacity, bookedCount}`).

Contoh document:
```json
{
  "doulaId": "doula_001",
  "tanggal": "2026-09-20",
  "slots": [
    {"time": "09:00", "capacity": 2, "bookedCount": 1},
    {"time": "10:00", "capacity": 1, "bookedCount": 1}
  ],
  "createdAt": 1726800000000
}
```

### Collection: `zoom_links` (BARU)
Field: `id`, `bookingId`, `doulaId`, `linkUrl`, `scheduledDate`, `scheduledTime`, `createdBy` ('admin'|'doula'), `createdAt`.

### Collection: `materi_access` (BARU untuk on-demand)
Field: `id`, `userId`, `bookingId`, `layanan` ('materi_online'|'paket_bundling'), `aksesSelamanya` (boolean), `createdAt`.

---

## 4. State Machine Transaksi

```
                    ┌──────────────┐
                    │   CREATED    │  (transaksi baru, status = 'pending')
                    │  (15 min)    │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
     ┌─────────────┐  ┌──────────┐  ┌──────────┐
     │   PAID      │  │ EXPIRED  │  │CANCELLED │
     │ (webhook    │  │ (>15 min │  │ (user    │
     │  settlement)│  │  no pay) │  │  cancel) │
     └──────┬──────┘  └──────────┘  └──────────┘
            │
            ▼
     ┌─────────────┐
     │  CONFIRMED  │  (auto untuk Chat/Yoga/Edukasi/Bundling;
     │  (Auto      │   manual opsional untuk Offline)
     │  Confirmed) │
     └──────┬──────┘
            │
            ▼
     ┌─────────────┐
     │   ONGOING   │  (layanan sedang berlangsung)
     └──────┬──────┘
            │
            ▼
     ┌─────────────┐
     │  COMPLETED  │  (layanan selesai)
     └─────────────┘
```

**Transisi:**
- `pending` → `paid`: via webhook Midtrans (`settlement`/`capture`) atau polling berhasil
- `pending` → `expired`: Cloud Function timer >15 menit
- `pending` → `cancelled`: user membatalkan sebelum bayar
- `paid` → `confirmed`: **Auto** untuk Chat Doula, Online Yoga, Materi Online, Paket Bundling. **Manual opsional** untuk Offline.
- `confirmed` → `ongoing`: layanan dimulai (auto-trigger berdasarkan waktu slot untuk layanan berjadwal)
- `ongoing` → `completed`: layanan selesai
- `ongoing` → `cancelled`: pembatalan di tengah jalan
- `paid` → `cancelled`: refund (jika kebijakan mengizinkan)

**Aturan auto-confirmation:**
- Chat Doula, Online Yoga, Materi Online, Paket Bundling → booking status otomatis `confirmed` saat webhook `settlement` diterima.
- Offline → booking tetap `paid` hingga doula/admin mengkonfirmasi secara manual.

**Aturan idempotency:** Webhook Midtrans memeriksa apakah transaksi sudah `paid` sebelum mengupdate. Jika sudah, skip.

---

## 5. Non-Functional Requirements

- **Security**: Server key Midtrans HARUS disimpan di Firebase Cloud Functions, TIDAK di client app. Client key boleh di app.
- **Idempotency**: Semua webhook handler menggunakan idempotency check terhadap transaction ID.
- **Audit Trail**: Setiap perubahan status booking/transaction mencatat `updatedAt` + `updatedBy` (user/admin/system).
- **Scalability**: Solusi Zoom link & slot booking harus work untuk 100+ pengguna concurrent tanpa bottleneck.
- **Real-time**: Status transaksi & booking di mobile harus update real-time via Firestore snapshot listener.
- **No Manual Verification**: Tidak ada status `pending_review` — semua pembayaran otomatis melalui Midtrans.
- **Auto-confirmation Latency**: Transisi `paid` → `confirmed` untuk layanan auto-confirmed harus terjadi dalam < 5 detik dari webhook diterima.
- **On-Demand Access**: Akses materi untuk layanan on-demand harus terbuka dalam < 3 detik setelah pembayaran dikonfirmasi.
