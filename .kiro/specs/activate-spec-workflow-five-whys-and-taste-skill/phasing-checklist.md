# Implementation Phasing Checklist
**Module**: Transaksi, Pembayaran & Layanan Doula (Momsie)
**Requirements File**: `.kiro/specs/activate-spec-workflow-five-whys-and-taste-skill/requirements.md`
**Created**: 2026-09-12

---

## Phase 1 — Foundation: Data Model & Service Layer

### Mobile (Flutter) — `D:\p2mw\app\mobile`
- [ ] **`lib/shared/util/model/booking_model.dart`** — Tambah field `zoomLink`, `isOnDemand`, `expiredAt`
- [ ] **`lib/shared/util/model/booking_slot_model.dart`** — Refactor dari `List<String>` ke `List<{time, capacity, bookedCount}>`
- [ ] **`lib/shared/util/model/transaksi_model.dart`** — Pastikan field `idempotencyKey`, `midtransOrderId` ada
- [ ] **`lib/shared/util/service/payment_service.dart`** — Tambah:
  - `autoConfirmBooking(bookingId, layanan)` — auto-transition paid→confirmed untuk layanan auto-confirmed
  - `expireBooking()` diperluas: release slot capacity saat expire
  - `getZoomLink(bookingId)` → read from `zoom_links` collection
- [ ] **`lib/shared/util/service/booking_slot_service.dart`** — Implement CRUD untuk booking_slots dengan capacity logic
- [ ] **`lib/shared/util/service/midtrans_service.dart`** — Update: pastikan Snap token creation via Cloud Functions (server-side)
- [ ] **`lib/shared/util/service/zoom_link_service.dart`** *(baru)* — CRUD zoom_links collection

### Admin Web (Next.js) — `D:\p2mw\momsie`
- [ ] **`app/dashboard/booking/page.tsx`** — Tambah kolom `zoomLink`, `isOnDemand`, filter by status expanded
- [ ] **`lib/dashboard-service.ts`** — Tambah type `Booking` fields: `zoomLink`, `isOnDemand`, `expiredAt`
- [ ] **`app/dashboard/zoom/page.tsx`** *(baru)* — Halaman CRUD link Zoom per jadwal
- [ ] **`app/dashboard/slots/page.tsx`** *(baru)* — Halaman view capacity & booked_count per doula per tanggal

---

## Phase 2 — Core Booking Flow (US-1, US-2)

### Mobile (Flutter)
- [ ] **`lib/features/user/kesehatan/booking_doula_controller.dart`** — Refactor:
  - Pisahkan logika jadwal vs on-demand based on `layanan` type
  - Integrasi `BookingSlotService` untuk load slots dengan capacity status
  - Disable slot jika `bookedCount >= capacity`
- [ ] **`lib/features/user/kesehatan/booking_doula_page.dart`** — Update UI:
  - Tampilkan badge "FULL" pada slot yang penuh
  - Sembunyikan date/time picker untuk layanan on-demand (Edukasi, Bundling)
  - Label "On-Demand" untuk layanan tanpa slot
- [ ] **`lib/shared/widget/payment_sheet.dart`** — Update:
  - Hapus opsi transfer manual
  - Hanya tampilkan Midtrans Snap
  - Tambah countdown timer 15 menit
  - PIN/biometrik auth sebelum buka sheet

### Admin Web (Next.js)
- [ ] (Tidak ada perubahan signifikan di phase ini)

---

## Phase 3 — Payment & Auto-Confirmation (US-3, US-9)

### Mobile (Flutter)
- [ ] **`lib/shared/util/service/payment_service.dart`** — Implement:
  - `processMidtransWebhook()` — idempotency check, auto-confirm logic
  - `releaseSlotCapacity(bookingId)` — decrease bookedCount saat expire/cancel
  - `startExpireTimer(bookingId, txId)` — Cloud Function trigger
- [ ] **`lib/shared/util/service/midtrans_service.dart`** — Tambah polling fallback logic
- [ ] **`lib/features/user/kesehatan/payment_success_page.dart`** — Update untuk handle auto-confirm state

### Cloud Functions (Firebase)
- [ ] **`functions/src/midtrans-webhook.ts`** *(baru)* — Webhook handler dengan idempotency
- [ ] **`functions/src/auto-confirm.ts`** *(baru)* — Auto-transition paid→confirmed
- [ ] **`functions/src/expire-pending.ts`** *(baru)* — Timer 15 menit → expired

### Admin Web (Next.js)
- [ ] **`app/api/webhooks/midtrans/route.ts`** *(baru)* — Edge function webhook endpoint

---

## Phase 4 — Zoom Link & Fallback WhatsApp (US-4, US-7)

### Mobile (Flutter)
- [ ] **`lib/features/user/pesanan/booking_detail_page.dart`** — Update:
  - Tampilkan zoomLink jika ada
  - Tampilkan badge + tombol WhatsApp fallback jika `zoomLink == null`
  - Tombol "Mulai Chat" untuk layanan Chat Doula
  - Tombol "Akses Materi" untuk layanan on-demand
- [ ] **`lib/features/user/pesanan/user_pesanan_page.dart`** — Update card actions per status & layanan type
- [ ] **`lib/features/user/chat/chat_controller.dart`** — Tambah validasi: only accessible jika booking status = paid/confirmed AND slot masih aktif
- [ ] **`lib/features/user/chat/chat_page.dart`** — Tambah waktu slot di header chat

### Admin Web (Next.js)
- [ ] **`app/dashboard/zoom/page.tsx`** — CRUD interface untuk zoom_links
- [ ] Real-time sync: admin input zoom link → mobile auto-update (Firestore listener)

---

## Phase 5 — Doula Dashboard (US-10, US-11)

### Mobile (Flutter) — Mitra Side
- [ ] **`lib/features/mitra/profil/mitra_aturjadwal_controller.dart`** — Implement slot management:
  - Create/edit/delete slots dengan capacity
  - View booked_count per slot
- [ ] **`lib/features/mitra/profil/mitra_aturjadwal_page.dart`** — UI slot management
- [ ] **`lib/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart`** — Tambah filter by slot & capacity status
- [ ] Notifikasi push: doula receive notification saat ada booking baru di slotnya

### Admin Web (Next.js)
- [ ] **`app/dashboard/slots/page.tsx`** — View capacity & booked_count overview

---

## Phase 6 — On-Demand Access (US-11)

### Mobile (Flutter)
- [ ] **`lib/shared/util/service/materi_access_service.dart`** *(baru)* — Manage materi_access collection
- [ ] **`lib/features/user/edukasi/user_detailprogram_page.dart`** — Tambah validasi: akses hanya jika booking status = paid/confirmed
- [ ] **`lib/features/user/edukasi/user_edukasi_page.dart`** — Tambah "Akses Materi" button untuk yang sudah paid

### Admin Web (Next.js)
- [ ] (Tidak ada perubahan signifikan)

---

## Phase 7 — Polish & Integration Tests

### Mobile (Flutter)
- [ ] **`lib/features/user/pesanan/user_pesanan_controller.dart`** — Verifikasi real-time stream filter (Aktif vs Riwayat)
- [ ] **`lib/features/user/kesehatan/booking_doula_controller.dart`** — Edge cases: concurrent booking, slot full, expire handling
- [ ] Chat room access control: verify only paid/confirmed bookings can enter
- [ ] WhatsApp fallback deep link testing

### Admin Web (Next.js)
- [ ] **`app/dashboard/transaksi/page.tsx`** — Verifikasi KPI calculations (15% platform fee, 85% doula earnings)
- [ ] **`app/dashboard/booking/page.tsx`** — Verifikasi inline status update works correctly
- [ ] Zoom CRUD: test create/edit/delete + sync to mobile

### Cloud Functions
- [ ] Webhook idempotency test (double callback)
- [ ] Expire timer test (15 min boundary)
- [ ] Auto-confirm latency test (< 5 seconds)

---

## Summary File Count by Phase

| Phase | Mobile Files | Admin Web Files | Cloud Functions |
|-------|-------------|-----------------|-----------------|
| 1 — Foundation | 6 | 4 | 0 |
| 2 — Core Booking | 3 | 0 | 0 |
| 3 — Payment | 3 | 1 | 3 |
| 4 — Zoom & Fallback | 4 | 1 | 0 |
| 5 — Doula Dashboard | 4 | 1 | 0 |
| 6 — On-Demand | 2 | 0 | 0 |
| 7 — Polish | 3 | 2 | 0 |
| **Total** | **25** | **9** | **3** |
