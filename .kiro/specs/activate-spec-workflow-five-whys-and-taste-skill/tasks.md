# Tasks — Modul Transaksi, Pembayaran & Layanan Doula (Momsie)
**Requirements**: `requirements.md` | **Design**: `design.md` | **Status**: DRAFT

---

## Phase 1 — Foundation: Data Model & Service Layer

### T-001: Update BookingModel dengan field baru
- [x] Tambah field `zoomLink` (String?)
- [x] Tambah field `isOnDemand` (bool)
- [x] Tambah field `expiredAt` (DateTime?)
- [x] Update `fromMap`, `toMap`, `copyWith`
- **File**: `lib/shared/util/model/booking_model.dart`
- **Dependencies**: None

### T-002: Refactor BookingSlotModel ke capacity-based
- [x] Ubah `slots: List<String>` → `slots: List<SlotItem>`
- [x] Buat `SlotItem` class/data class: `{time, capacity, bookedCount}`
- [x] Update `fromMap`, `toMap`, `copyWith`
- **File**: `lib/shared/util/model/booking_slot_model.dart`
- **Dependencies**: None

### T-003: Update TransaksiModel
- [x] Tambah field `idempotencyKey` (String)
- [x] Tambah field `midtransOrderId` (String?)
- [x] Tambah field `platformFee` (int)
- [x] Tambah field `doulaEarnings` (int)
- **File**: `lib/shared/util/model/transaksi_model.dart`
- **Dependencies**: T-001

### T-004: Implementasi BookingSlotService dengan capacity logic
- [x] Method: `getAvailableSlots(doulaId, tanggal)` — return slots + full status
- [x] Method: `createSlot(doulaId, tanggal, time, capacity)`
- [x] Method: `updateSlotCapacity(doulaId, tanggal, time, newCapacity)`
- [x] Method: `deleteSlot(doulaId, tanggal, time)` — hanya jika bookedCount == 0
- [x] Method: `incrementBookedCount(doulaId, tanggal, time)` — via Firestore transaction
- [x] Method: `decrementBookedCount(doulaId, tanggal, time)` — via Firestore transaction
- **File**: `lib/shared/util/service/booking_slot_service.dart`
- **Dependencies**: T-002

### T-005: Implementasi ZoomLinkService
- [x] Method: `getZoomLink(bookingId)` → String?
- [x] Method: `createZoomLink(bookingId, doulaId, linkUrl, scheduledDate, scheduledTime, createdBy)`
- [x] Method: `updateZoomLink(bookingId, linkUrl)`
- [x] Method: `deleteZoomLink(bookingId)`
- **File**: `lib/shared/util/service/zoom_link_service.dart` (baru)
- **Dependencies**: None

### T-006: Update PaymentService — auto-confirm & expire dengan capacity release
- [x] Method: `autoConfirmBooking(bookingId, layanan)` — transition paid→confirmed untuk auto-confirm services
- [x] Method: `expireBookingWithCapacityRelease(transactionId)` — expire + decrement bookedCount
- [x] Method: `getZoomLinkForBooking(bookingId)` — delegate ke ZoomLinkService
- **File**: `lib/shared/util/service/payment_service.dart`
- **Dependencies**: T-004, T-005

---

## Phase 2 — Core Booking Flow (US-1, US-2)

### T-007: Refactor BookingDoulaController — on-demand vs scheduled branching
- [x] Deteksi jenis layanan: on-demand (materi_online, paket_bundling) vs scheduled (chat_doula, prenatal_yoga, doula_offline)
- [x] Untuk on-demand: skip date/time picker, langsung ke confirmation
- [x] Untuk scheduled: load slots dari BookingSlotService, disable FULL slots
- [x] Tambah validasi: alamat wajib untuk doula_offline
- **File**: `lib/features/user/kesehatan/booking_doula_controller.dart`
- **Dependencies**: T-001, T-004

### T-008: Update BookingDoulaPage UI
- [x] Tampilkan badge "FULL" pada slot yang penuh
- [x] Conditional render: date/time picker hanya untuk scheduled services
- [x] Label "On-Demand" untuk materi_online & paket_bundling
- [x] Tombol "Lanjutkan ke Konfirmasi" aktif hanya jika semua field wajib terisi
- **File**: `lib/features/user/kesehatan/booking_doula_page.dart`
- **Dependencies**: T-007

### T-009: Update PaymentSheet — Snap-only + countdown + PIN auth
- [x] Hapus semua opsi metode pembayaran selain Midtrans Snap
- [x] Hapus manual transfer flow
- [x] Update polling: 18×10s = 3 menit max
- [x] Auto-confirm call setelah pembayaran berhasil
- **File**: `lib/shared/widget/payment_sheet.dart`
- **Dependencies**: T-006

### T-010: Implementasi MidtransSnap flow di PaymentService
- [x] Method: `createSnapToken(totalBayar, orderId, customerName, email, returnURL)` — call Cloud Function
- [x] Method: `openMidtransSnap(snapToken)` — buka Midtrans checkout
- [x] Method: `pollPaymentStatus(orderId, maxRetries: 18, interval: 10s)` — fallback polling
- **File**: `lib/shared/util/service/midtrans_service.dart`
- **Dependencies**: T-006

---

## Phase 3 — Payment & Auto-Confirmation (US-3, US-9)

### T-011: Cloud Function — Midtrans Webhook Handler
- [ ] Setup Firebase Cloud Function: `midtrans-webhook`
- [ ] Implement signature verification (HMAC-SHA512)
- [ ] Idempotency check: skip jika transaction sudah paid
- [ ] Update transaction.status = 'paid' + paidAt
- [ ] Update booking.status = 'paid' + paidAt
- [ ] Call auto-confirm logic berdasarkan layanan type
- [ ] Insert ke materi_access untuk on-demand services
- **File**: `functions/src/midtrans-webhook.ts` (baru)
- **Dependencies**: T-006

### T-012: Cloud Function — Auto-Confirm Logic
- [ ] Function: `autoConfirmOnSettlement(transactionId)`
- [ ] Cek layanan: jika in [chat_doula, prenatal_yoga, materi_online, paket_bundling] → set booking.status = 'confirmed'
- [ ] Jika doula_offline → biarkan status 'paid' (tunggu manual confirm)
- **File**: `functions/src/auto-confirm.ts` (baru)
- **Dependencies**: T-011

### T-013: Cloud Function — Expire Timer
- [ ] Function: `expirePendingBookings()` — triggered by Cloud Scheduler every minute
- [ ] Query: bookings with status='pending' AND createdAt < now - 15min
- [ ] Untuk tiap booking: expire transaction + booking + release slot capacity
- **File**: `functions/src/expire-pending.ts` (baru)
- **Dependencies**: T-006, T-004

### T-014: Next.js API Route — Webhook Endpoint
- [ ] Buat `app/api/webhooks/midtrans/route.ts`
- [ ] Forward webhook ke Cloud Function (atau implement directly)
- [ ] Return 200 on success, 400/403 on invalid signature
- **File**: `app/api/webhooks/midtrans/route.ts` (baru)
- **Dependencies**: T-011

---

## Phase 4 — Zoom Link & Fallback WhatsApp (US-4, US-7)

### T-015: Update BookingDetailPage — Zoom link display + WhatsApp fallback
- [x] Fetch zoomLink dari ZoomLinkService
- [x] Jika zoomLink != null → tampilkan "Join Zoom Meeting" button
- [x] Jika zoomLink == null DAN status ∈ [paid, confirmed] → tampilkan badge + tombol WhatsApp
- [x] WhatsApp deep link: `https://wa.me/628xxxxxxxxxx?text=${encodeURIComponent(template)}`
- **File**: `lib/features/user/pesanan/booking_detail_page.dart`
- **Dependencies**: T-005, T-010

### T-016: Update UserPesananPage — card actions per status & service type
- [x] Action mapping:
  - pending → "Bayar Sekarang"
  - paid/confirmed/ongoing + chat_doula → "Mulai Chat"
  - paid/confirmed/ongoing + online (with zoomLink) → "Join Zoom"
  - paid/confirmed/ongoing + online (no zoomLink) → "Hubungi Admin WhatsApp"
  - paid/confirmed + on-demand → "Akses Materi"
  - paid → "Lihat Bukti Bayar"
- **File**: `lib/features/user/pesanan/user_pesanan_page.dart`
- **Dependencies**: T-015

### T-017: Update ChatController — access control validation
- [x] Sebelum navigate ke chat page, validasi:
  - booking.status ∈ ['paid', 'confirmed', 'ongoing']
  - Untuk scheduled services: current time within slot window (±5 min)
  - Untuk on-demand: skip time check
- [x] Jika gagal validasi → tampilkan snackbar "Chat belum tersedia"
- **File**: `lib/features/user/chat/chat_controller.dart`
- **Dependencies**: T-016

### T-018: Update ChatPage — slot time display
- [x] Tampilkan tanggal + jam slot di header chat
- [x] Tampilkan durasi slot (1 jam)
- [x] Tampilkan indicator "Sedang Berlangsung" atau "Belum Mulai"
- **File**: `lib/features/user/chat/chat_page.dart`
- **Dependencies**: T-017

---

## Phase 5 — Doula Dashboard (US-10)

### T-019: Update MitraAturJadwalController — slot management
- [x] Method: `loadMySlots(tanggal)` — fetch dari BookingSlotService
- [x] Method: `createSlot(tanggal, time, capacity)`
- [x] Method: `updateSlotCapacity(time, newCapacity)`
- [x] Method: `deleteSlot(time)` — only if bookedCount == 0
- [x] Method: `getBookingsForSlot(tanggal, time)` — fetch bookings per slot
- **File**: `lib/features/mitra/profil/mitra_aturjadwal_controller.dart`
- **Dependencies**: T-004

### T-020: Update MitraAturJadwalPage — UI slot management
- [x] Tampilkan daftar slot untuk tanggal terpilih
- [x] Setiap slot: time, capacity, bookedCount, status (AVAILABLE/FULL)
- [x] Form tambah slot baru (time + capacity)
- [x] Form edit capacity slot existing
- [x] Tombol hapus slot (disable jika bookedCount > 0)
- **File**: `lib/features/mitra/profil/mitra_aturjadwal_page.dart`
- **Dependencies**: T-019

### T-021: Update MitraPekerjaanController — slot-based filtering
- [x] Filter bookings by slot date + time
- [x] Show capacity utilization per slot
- **File**: `lib/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart`
- **Dependencies**: T-020

### T-022: Admin Web — Slots Overview Page
- [x] Tampilkan semua doula + their slots + capacity + booked_count
- [x] Filter by date range
- [x] Color code: green (<70%), yellow (70-99%), red (>=100%)
- **File**: `app/dashboard/slots/page.tsx` (baru)
- **Dependencies**: T-004

---

## Phase 6 — On-Demand Access (US-11)

### T-023: Implement MateriAccessService
- [x] Method: `grantAccess(userId, bookingId, layanan)`
- [x] Method: `hasAccess(userId, layanan)` → bool
- [x] Method: `getAccessedList(userId)` → List<String>
- [x] Method: `streamAccess(userId, layanan)` → Stream<bool>
- [x] Method: `revokeAccess(userId, layanan)`
- **File**: `lib/shared/util/service/materi_access_service.dart` (baru)
- **Dependencies**: T-003

### T-024: Update Edukasi Pages — access gating
- [x] `user_detailprogram_page.dart`: Check `MateriAccessService.hasAccess()` sebelum tampilkan materi
- [x] `user_edukasi_page.dart`: Tambah button "Akses Materi" untuk layanan on-demand yang sudah paid
- **File**: `lib/features/user/edukasi/user_detailprogram_page.dart`, `user_edukasi_page.dart`
- **Dependencies**: T-023

---

## Phase 7 — Polish & Integration

### T-025: Update UserPesananController — real-time stream filtering
- [x] Stream bookings untuk user saat ini (FireStore snapshots)
- [x] Filter tab "Aktif": status ∈ ['pending', 'paid', 'confirmed', 'ongoing']
- [x] Filter tab "Riwayat": status ∈ ['completed', 'cancelled', 'expired']
- [x] Auto-refresh setiap ada perubahan status dari Firestore
- **File**: `lib/features/user/pesanan/user_pesanan_controller.dart`
- **Dependencies**: T-016

### T-026: Edge Cases & Error Handling
- [ ] Test: concurrent booking attempt on same slot (race condition)
- [ ] Test: booking expire while user is in payment flow
- [ ] Test: zoomLink added after booking created → UI auto-updates
- [ ] Test: WhatsApp fallback link format validation
- [ ] Test: on-demand service payment → immediate materi access
- **Files**: Multiple (integration testing across phases)
- **Dependencies**: All previous tasks

### T-027: Admin Dashboard — Zoom CRUD Page
- [x] Tampilkan daftar semua zoom_links dengan filter by doula/date
- [x] Form tambah zoom link baru (bookingId + linkUrl + scheduledDate + scheduledTime)
- [x] Edit/delete existing zoom links
- **File**: `app/dashboard/zoom/page.tsx` (baru)
- **Dependencies**: T-005

### T-028: Admin Dashboard — Booking & Transaksi Enhancement
- [x] Tambah kolom `zoomLink` di tabel booking
- [x] Tambah kolom `isOnDemand` di tabel booking
- [x] Filter by `isOnDemand`
- [x] Inline status update dropdown expanded (tambah 'expired' option)
- **File**: `app/dashboard/booking/page.tsx`
- **Dependencies**: T-001

---

## Task Dependencies Summary

```
T-001 → T-003 → T-006 → T-010 → T-015 → T-016 → T-025
  ↓       ↓       ↓       ↓       ↓       ↓       ↓
T-002 → T-004 → T-011 → T-015   T-017   T-026
  ↓       ↓       ↓
T-005 → T-012   T-013
  ↓
T-015 → T-018
        ↓
T-019 → T-020 → T-021 → T-022
  ↓
T-023 → T-024
  ↓
T-027 → T-028
```

## Estimated Effort (per task)

| Task | Est. Time | Complexity |
|------|-----------|------------|
| T-001 | 30 min | Low |
| T-002 | 1 hr | Low |
| T-003 | 30 min | Low |
| T-004 | 2 hr | Medium |
| T-005 | 1 hr | Low |
| T-006 | 1.5 hr | Medium |
| T-007 | 2 hr | Medium |
| T-008 | 1.5 hr | Medium |
| T-009 | 2 hr | Medium |
| T-010 | 1.5 hr | Medium |
| T-011 | 3 hr | High |
| T-012 | 1 hr | Low |
| T-013 | 2 hr | Medium |
| T-014 | 1 hr | Low |
| T-015 | 2 hr | Medium |
| T-016 | 2 hr | Medium |
| T-017 | 1.5 hr | Medium |
| T-018 | 1 hr | Low |
| T-019 | 2 hr | Medium |
| T-020 | 2 hr | Medium |
| T-021 | 1.5 hr | Low |
| T-022 | 2 hr | Medium |
| T-023 | 1 hr | Low |
| T-024 | 1.5 hr | Medium |
| T-025 | 1.5 hr | Medium |
| T-026 | 3 hr | High (testing) |
| T-027 | 2 hr | Medium |
| T-028 | 1.5 hr | Low |
| **TOTAL** | **~43 jam** | |
