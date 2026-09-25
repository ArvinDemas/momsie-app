# Design — Modul Transaksi, Pembayaran & Layanan Doula (Momsie)
**Requirements**: `requirements.md` | **Status**: FINAL

---

## 1. Architecture Overview

```
┌──────────────────────────────────────────────────────────────┐
│                    Flutter Mobile App                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │ BookingFlow  │  │ PaymentSheet │  │ ChatRoom / Zoom  │  │
│  │ Controller   │  │ (Midtrans)   │  │ Access Controller│  │
│  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘  │
│         │                 │                   │             │
│  ┌──────▼─────────────────▼───────────────────▼─────────┐  │
│  │           PaymentService + BookingSlotService        │  │
│  │           MidtransService (Snap Token)               │  │
│  └──────────────────────────┬───────────────────────────┘  │
└─────────────────────────────┼───────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼
┌──────────────────┐ ┌───────────────┐ ┌──────────────────┐
│  Firestore       │ │  Firebase     │ │  Cloud Functions  │
│  - bookings      │ │  Storage      │ │  - webhook handler│
│  - transactions  │ │  - bukti      │ │  - auto-confirm   │
│  - booking_slots │ │               │ │  - expire timer   │
│  - zoom_links    │ │               │ │  - capacity update│
└──────────────────┘ └───────────────┘ └──────────────────┘
                              │
              ┌───────────────┘
              ▼
┌────────────────────────────────────────────────────────────┐
│                  Midtrans API (Server-side)                │
│          Snap Token → Checkout URL → Settlement Webhook    │
└────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┘
              ▼
┌────────────────────────────────────────────────────────────┐
│              Admin Web Dashboard (Next.js)                 │
│  booking | transaksi | doula | zoom | slots | withdrawal   │
└────────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Payment token generation | **Server-side** (Cloud Functions) | Server key must never reach client. Midtrans SDK runs in Cloud Function. |
| Status sync approach | **Firestore snapshot listener** | Real-time auto-update; no polling needed on mobile. |
| Auto-confirmation trigger | **Cloud Function on webhook** | Webhook → Cloud Function → Firestore write → mobile listener picks up. |
| Slot capacity tracking | **`booking_slots` collection** with atomic increment | Concurrent bookings handled via Firestore transactions (see §3). |
| On-demand vs scheduled bifurcation | **`isOnDemand` boolean flag** on booking | Single model, clean UI branching logic. |
| WhatsApp fallback | **Deep link** (`wa.me` with template) | No backend needed; opens native WhatsApp app. |
| Chat room gate | **Controller-side validation** before navigation | Check booking status + slot time window before allowing entry. |

---

## 2. State Machine — Detailed

### 2.1 Booking State Machine

```
                    ┌─────────────────┐
                    │     PENDING     │  ← Transaksi baru dibuat
                    │  (timer 15 min) │
                    └────────┬────────┘
                             │
              ┌──────────────┼────────────────┐
              │              │                │
              ▼              ▼                ▼
     ┌──────────────┐ ┌───────────┐   ┌──────────────┐
     │     PAID     │ │  EXPIRED  │   │  CANCELLED   │
     │  (webhook    │ │  (>15 min │   │  (user cancels│
     │   settlement)│ │  no pay)  │   │   before pay)│
     └──────┬───────┘ └───────────┘   └──────────────┘
            │
            ▼
     ┌───────────────┐
     │   CONFIRMED   │  ← Branching point:
     │               │  • Auto for: Chat, Yoga, Edukasi, Bundling
     │               │  • Manual (optional) for: Offline
     └───────┬───────┘
             │
             ▼
     ┌───────────────┐
     │   ONGOING     │  ← Auto-triggered by scheduler when slot time arrives
     └───────┬───────┘
             │
             ▼
     ┌───────────────┐
     │  COMPLETED    │  ← Service done (or auto after N hours for online)
     └───────────────┘
```

### 2.2 Branching Logic (Auto vs Manual Confirm)

```dart
// Logic embedded in webhook handler (Cloud Function)
bool isAutoConfirm(String layanan) {
  return [
    'chat_doula',
    'prenatal_yoga',
    'materi_online',
    'paket_bundling'
  ].contains(layanan);
}

// Auto-confirm path:
//   webhook settlement → paid → confirmed (immediate)
// Manual-confirm path (Offline only):
//   webhook settlement → paid → (waiting for doula/admin) → confirmed
```

### 2.3 Slot Capacity State

```
booking_slots doc: {doulaId, tanggal, slots}
slot: {time, capacity, bookedCount}

Transisi saat booking created:
  Firestore transaction: bookedCount++ (atomic)

Transisi saat booking expired/cancelled:
  Firestore transaction: bookedCount-- (atomic)

Transisi saat slot capacity changed by doula:
  Direct update: capacity = new value (no transaction needed)
```

---

## 3. Data Flow — End-to-End Transaction

### 3.1 Booking Creation (Client → Firestore)

```
1. User selects doula + date + time + layanan
2. BookingDoulaController calls BookingSlotService.getSlots(doulaId, tanggal)
3. UI renders available slots; FULL slots disabled
4. User confirms → controller calls PaymentService.createBookingTransaction()
5. Transaction + Booking documents created atomically (Firestore batch)
6. Snap token requested from Cloud Function (server-side)
7. Mobile receives snapToken → open Midtrans checkout
8. Countdown timer starts (15 min)
```

### 3.2 Payment Success Path (Webhook → Auto-Confirm)

```
1. Customer completes payment via Midtrans Snap
2. Midtrans POSTs webhook to Cloud Function: /api/webhooks/midtrans
3. Cloud Function:
   a. Idempotency check: if transaction already paid → skip
   b. Update transaction.status = 'paid', paidAt = now
   c. Update booking.status = 'paid', paidAt = now
   d. Call isAutoConfirm(layanan):
      - TRUE  → booking.status = 'confirmed', confirmedAt = now
      - FALSE → stay 'paid' (await manual confirm)
   e. For on-demand services → insert into materi_access collection
4. Mobile snapshot listener detects change → UI updates in real-time
```

### 3.3 Slot Capacity Management

```
Booking creation (increment):
  Firestore transaction:
    1. Read booking_slot doc
    2. Find matching slot by date + time
    3. Assert bookedCount < capacity
    4. bookedCount++
    5. Write back

Booking expiration (decrement):
  Firestore transaction:
    1. Read booking_slot doc
    2. Find matching slot
    3. bookedCount-- (min 0)
    4. Write back
```

### 3.4 Zoom Link Fallback Flow

```
Mobile checks zoomLink on booking detail page:
  if zoomLink != null → show "Join Zoom Meeting" button
  if zoomLink == null → show:
    - Badge: "Menunggu Link Kelas dari Admin"
    - Button: "Hubungi Admin via WhatsApp" → deep link to wa.me/628xxx with template
```

### 3.5 Chat Room Access Control

```
Before navigating to chat page:
  1. Fetch booking by bookingId
  2. Check: booking.status ∈ ['paid', 'confirmed', 'ongoing']
  3. For scheduled services: check current time within slot window (±5 min buffer)
  4. For on-demand services: skip time check, just check status
  5. If all pass → navigate to ChatPage
```

---

## 4. Technical Options Analysis

### 4.1 Auto-Confirmation Implementation

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **A: Cloud Function on webhook** | Clean separation, no client race condition, server key safe | Requires CF setup | ✅ **SELECTED** |
| B: Client-side status update | Simpler, no CF needed | Exposes logic to client, race condition risk | ❌ Rejected |
| C: Firestore security rule trigger | Fully declarative | Hard to debug, limited conditional logic | ❌ Rejected |

### 4.2 Slot Capacity Concurrency

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **A: Firestore transaction** | Atomic, no double-booking | Slightly more complex | ✅ **SELECTED** |
| B: Client-side increment | Simple | Race condition: 2 users book same slot simultaneously | ❌ Rejected |
| C: Separate counter document | Fast reads | Requires extra doc, still needs transaction | ❌ Rejected |

### 4.3 Countdown Timer Implementation

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **A: Cloud Function timer** | Accurate, works offline, no client abuse | Requires CF setup | ✅ **SELECTED** |
| B: Client-side countdown | No backend needed | Clock skew, easily manipulated | ❌ Rejected |
| C: Hybrid (client display + server validation) | Balanced | More complex | ⚠️ Acceptable alternative |

### 4.4 On-Demand Access Gating

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **A: materi_access collection + client check** | Clean, explicit access control | Extra collection | ✅ **SELECTED** |
| B: Check booking status directly | Simpler, no extra data | Less scalable if content restrictions grow | ⚠️ Acceptable for MVP |
| C: Download content to local storage | Works offline | Large storage, no server control | ❌ Rejected |

---

## 5. API Contract — Cloud Functions

### 5.1 Create Snap Token

```
POST https://api.adacode.ai/functions/createMidtransSnap
Body: {
  orderId: string,        // "ORDER-TRX_ID"
  amount: number,         // totalBayar in IDR
  customerName: string,
  userEmail: string,
  returnURL: string       // deep link back to app
}
Response: { snapToken: string, redirectURL: string }
```

### 5.2 Webhook Handler

```
POST https://api.adacode.ai/functions/midtrans-webhook
Headers: { Authorization: Bearer [server-secret] }
Body (Midtrans format):
{
  transaction_time: string,
  transaction_status: string,  // "settlement", "capture", "pending", "expire", "cancel"
  fraud_status: string,
  order_id: string,            // matches orderId sent to Midtrans
  gross_amount: number,
  payment_type: string,
  signature_key: string        // verify signature
}
Response: { status: "processed" }
```

### 5.3 Webhook Signature Verification

```
secretKey = FIREBASE_SECRET_KEY (from Cloud Function env)
expectedSig = SHA512(order_id + transaction_id + gross_amount + secretKey)
if signature_key == expectedSig → proceed
else → return 403
```

---

## 6. Component Mapping

### 6.1 Mobile (Flutter) — Files to Modify/Create

| File | Action | Purpose |
|------|--------|---------|
| `lib/shared/util/model/booking_model.dart` | **MODIFY** | Add `zoomLink`, `isOnDemand`, `expiredAt` |
| `lib/shared/util/model/booking_slot_model.dart` | **MODIFY** | Refactor to capacity-based slots |
| `lib/shared/util/model/transaksi_model.dart` | **MODIFY** | Add `idempotencyKey`, `midtransOrderId` |
| `lib/shared/util/service/payment_service.dart` | **MODIFY** | Auto-confirm, expire with capacity release |
| `lib/shared/util/service/booking_slot_service.dart` | **MODIFY** | Capacity-aware CRUD with transactions |
| `lib/shared/util/service/midtrans_service.dart` | **MODIFY** | Server-side token, polling fallback |
| `lib/shared/util/service/zoom_link_service.dart` | **CREATE** | Zoom link CRUD |
| `lib/features/user/kesehatan/booking_doula_controller.dart` | **MODIFY** | On-demand vs scheduled branching |
| `lib/features/user/kesehatan/booking_doula_page.dart` | **MODIFY** | UI: full slots, on-demand mode |
| `lib/shared/widget/payment_sheet.dart` | **MODIFY** | Snap-only, countdown, PIN auth |
| `lib/features/user/pesanan/booking_detail_page.dart` | **MODIFY** | Zoom link, WhatsApp fallback, chat button |
| `lib/features/user/pesanan/user_pesanan_page.dart` | **MODIFY** | Card actions per status & service type |
| `lib/features/user/chat/chat_controller.dart` | **MODIFY** | Access control validation |
| `lib/features/user/chat/chat_page.dart` | **MODIFY** | Slot time display in header |
| `lib/features/mitra/profil/mitra_aturjadwal_controller.dart` | **MODIFY** | Slot management UI logic |
| `lib/features/mitra/profil/mitra_aturjadwal_page.dart` | **MODIFY** | Slot management UI |

### 6.2 Admin Web (Next.js) — Files to Modify/Create

| File | Action | Purpose |
|------|--------|---------|
| `app/dashboard/booking/page.tsx` | **MODIFY** | Add zoomLink column, isOnDemand filter |
| `lib/dashboard-service.ts` | **MODIFY** | Extend Booking type |
| `app/dashboard/zoom/page.tsx` | **CREATE** | Zoom link CRUD interface |
| `app/dashboard/slots/page.tsx` | **CREATE** | Capacity & booked_count overview |
| `app/api/webhooks/midtrans/route.ts` | **CREATE** | Edge function webhook endpoint |

---

## 7. Pricing Matrix (Reference)

| Layanan | Harga | Slot Required? | Auto-Confirm? | Access After Paid |
|---------|-------|---------------|---------------|-------------------|
| Chat Doula | Rp 30.000 | ✅ Yes (1 jam) | ✅ Yes | Chat room |
| Online Edukasi | Rp 99.000 | ❌ No (On-Demand) | ✅ Yes | Materi portal |
| Online Yoga | Rp 75.000 | ✅ Yes (Live Zoom) | ✅ Yes | Zoom link |
| Online Bundling | Rp 135.000 | ❌ No (On-Demand) | ✅ Yes | Materi portal |
| Offline Doula | Rp 3.000.000 | ✅ Yes | ⚠️ Manual | Physical visit |

---

## 8. Security Considerations

1. **Server Key Protection**: Midtrans server key only in Cloud Functions / Next.js API routes. Never in Flutter app.
2. **Webhook Signature**: All webhook requests verified with HMAC-SHA512 before processing.
3. **Idempotency**: Webhook handler checks `transactionId` before applying state changes.
4. **Slot Race Condition**: All capacity changes use Firestore transactions (optimistic locking).
5. **Chat Access Control**: Validation on both client (UI gate) and server (Firestore security rules) sides.
6. **PII Masking**: Admin dashboard masks customer names; toggle to reveal requires re-auth.

---

## 9. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Double-booking same slot | Medium | High | Firestore transactions prevent concurrent over-capacity |
| Webhook arrives after mobile UI updates | Low | Medium | Mobile re-subscribes to stream on reconnect |
| Midtrans sandbox → production key mismatch | Low | High | Environment-aware config service |
| Customer expires booking but slot not released | Medium | High | Cloud Function expire handler includes slot decrement |
| Doula changes capacity mid-session | Low | Medium | Capacity changes are immediate; future bookings respect new capacity |
| WhatsApp fallback link broken | Low | Medium | Use validated `wa.me` format with encoded message |

---

## 10. Open Questions

1. **Chat room time window**: Should customers be allowed to enter chat 5 minutes before slot start? (Recommended: yes, for preparation)
2. **Zoom link sharing**: Can doula share their personal Zoom link instead of admin-created link? (Recommended: yes, support both `createdBy: 'doula'` and `'admin'`)
3. **Refund policy**: What triggers a refund vs. simple cancellation? (Out of scope for this spec — handled in separate financial policy)
4. **On-demand materi access expiry**: Is "selamanya" truly permanent, or should there be a platform-defined retention policy? (Recommend: permanent for MVP, add expiry field later)
