# Momsie Design Audit & Elevation Plan
**Tanggal:** 2026-09-08 | **Status:** PARTIAL - Fix #4 SELESAI (AI Slop Patterns)

---

## Executive Summary

Momsie memiliki fondasi desain yang solid (design system tokens, glassmorphism navbar, themed background) tapi tersesat di eksekusi. **181 box-shadow hardcode**, **0 penggunaan AppSemanticColors.textPrimary** di 4 halaman utama yang dibaca, font **OpenSans** yang bertabrakan dengan **Poppins**, dan gradient biru-ungu-pink yang meniru Gemini AI — semuanya adalah tanda "AI slop" yang terdeteksi.

Beranda sudah paling dekat dengan elegant (bento grid, SizeGuide card), tapi halaman internal (Diary, Checklist, BabyNames, AI Chat) masih terasa seperti template generik Flutter.

---

## Part 1: AI Slop Patterns Terdeteksi

### 1.1 🟣 Blue-Purple-Pink AI Gradient (CRITICAL)
**Lokasi:** `ai_chat_page.dart:221`, `user_beranda_page.dart:285,481`
```dart
colors: const [Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFFF43F5E)]
```
**Masalah:** Gradient biru→ungu→pink ini identik dengan branding Google Gemini/AI generik. Tidak ada hubungan dengan identitas kehamilan/maternity. Membaca app momsie → tiba-tiba jadi app AI startup.

**Fix:** Ganti dengan palette hangat berbasis pink-rose/gold yang lebih maternal:
```dart
// Warm maternal gradient
const [Color(0xFFBE185D), Color(0xFFF472B6), Color(0xFFFFD1DC)]
// Atau soft coral
const [Color(0xFFE11D48), Color(0xFFF43F5E), Color(0xFFFF9A9E)]
```

### 1.2 ⬛ Slate-900 Hardcoded (`0xFF0F172A`) (HIGH)
**Lokasi:** 19 tempat, termasuk doula container, birth plan, AI chat, checklist
**Masalah:** `0xFF0F172A` = slate-900 dari Tailwind. App Momsie harusnya pakai palet warm, bukan cool neutral. Ini vibe corporate dashboard, bukan maternity app.

**Fix:** Gunakan warna yang konsisten di design system — tambahkan ke `AppSemanticColors`:
```dart
static Color get textDark => const Color(0xFF3D1F1F); // warm dark
// atau tetap pakai #1E293B yang sudah ada tapi konsisten
```

### 1.3 🔤 OpenSans vs Poppins Inconsistency (MEDIUM)
**Lokasi:** `checklist_page.dart:37`, `baby_names_page.dart:35`, `admin_dashboard_page.dart` (6x)
**Masalah:** Design system menyebut `fontFamily = 'Poppins'` tapi 3+ halaman pakai `OpenSans`. Font yang berbeda di layar yang sama = visual disonansi.

**Fix:** Hapus semua `fontFamily: 'OpenSans'` dari user pages. Admin pages bisa tetap OpenSans kalau mau beda identitas.

### 1.4 😊 Emoji di Suggestion Chips (LOW)
**Lokasi:** `ai_chat_page.dart:190-205`
```dart
'icon': '🌸', 'icon': '🧘‍♀️', 'icon': '🍏', 'icon': '🎒'
```
**Masalah:** Emoji di suggestion chips terasa casual/cheap untuk app kesehatan. Apple Health, Calm, dan app premium lainnya pakai icon set konsisten (bukan emoji unicode).

**Fix:** Ganti dengan Material Icons yang sesuai:
- 🌸 → `Icons.lab_profile_rounded` atau `Icons.medical_services_rounded`
- 🧘‍♀️ → `Icons.sports_yoga_rounded`
- 🍏 → `Icons.eco_rounded` atau `Icons.restaurant_outlined`
- 🎒 → `Icons.backpack_rounded` (sudah ada di data model)

### 1.5 🎨 Setiap Card Pakai Shadow Berbeda (MEDIUM)
**Lokasi:** 147 box-shadow di shared widgets + 46 di user features
**Masalah:** Shadow blurRadius bervariasi dari 6 sampai 20, offset dari 2 sampai 8, alpha dari 0.03 sampai 0.35. Tiap developer (atau AI) menulis shadow random. Tidak ada hierarki visual yang konsisten.

**Fix:** Gunakan `AppElevation.level1/2/3` yang sudah didefinisikan di design system:
- level1: blur 6, offset (0,2), alpha 0.04 → card kecil/badge
- level2: blur 12, offset (0,4), alpha 0.08 → card utama
- level3: blur 20, offset (0,8), alpha 0.12 → hero card/banner

---

## Part 2: Per-Layar Critique

### 2.1 Beranda (`user_beranda_page.dart`) — SCORE: 7/10
**Yang bagus:**
- Bento grid layout sudah modern dan terstruktur
- SizeGuideCard dengan Apple Arcade style enak dilihat
- Glassmorphism navbar bagus
- Carousel dots animation smooth

**Yang perlu ditingkatkan:**
- **Hero banner carousel** (4 slides): Setiap slide punya gradient warna berbeda sendiri-sendiri (pink, blue-purple-pink, purple, teal). Terlalu ramai. Konsistenkan 2-3 gradient palette saja.
- **"Layanan & Fitur Utama"** section title: Font hardcoded `AppTypography.h3` tapi tanpa semantic color. Gunakan `AppSemanticColors.textPrimary`.
- **Bento cards** (`_bentoCard`): Border tipis `color: color.withValues(alpha: 0.15)` terlalu samar, hampir tidak terlihat. Bisa dihilangkan atau diperkuat.
- **AI Chatbot card** (`_bentoCardWide`): Gradient 3 warna seperti Point 1.1 — ganti dengan warm palette.
- **Section spacing**: `AppSpacing.xxl` (32px) terlalu besar untuk pemisah section. Turunkan ke `AppSpacing.lg` (20px).

### 2.2 Doula/Kesehatan (`user_kesehatan_page.dart`) — SCORE: 5.5/10
**Yang bagus:**
- Promo carousel 4:3 aspect ratio bagus
- Pesanan Saya card dengan gradient pink menarik

**Yang perlu ditingkatkan:**
- **"Mitra Doula Terpercaya"** title: Hardcoded `TextStyle(fontSize: 18, fontWeight: FontWeight.bold)` — jangan pakai raw TextStyle, pakai `AppTypography.h3`.
- **Doula grid** (2 kolom, ratio 0.68): Aspect ratio 0.68 terlalu tinggi (card terlalu panjang). Standard Apple/Google card ratio = 0.75-0.8 untuk image-heavy cards. Naikkan ke `0.75`.
- **Empty state**: `"Tidak ada doula ditemukan"` — hardcoded TextStyle,灰色. Tambahkan illustration atau empty state yang lebih friendly.
- **Shadow di promo carousel**: blurRadius 14, offset (0,4) — tidak konsisten dengan AppElevation.

### 2.3 SizeGuide Card (`sizeguide_card.dart`) — SCORE: 8/10
**Sudah bagus.** Hanya perlu:
- Shadow `blurRadius: 20, alpha: 0.25` terlalu kuat untuk card yang sudah punya gradient overlay. Kurangi ke `AppElevation.level2` (alpha 0.08).
- Text "LIHAT" → kurang informatif. "LIHAT PERKEMBANGAN →" lebih deskriptif.

### 2.4 Diary (`diary_list_page.dart`) — SCORE: 6/10
**Yang bagus:**
- Empty state dengan icon circle pink enak
- Photo strip di card detail bagus
- Mood badge + pregnancy week pill di header card

**Yang perlu ditingkatkan:**
- **Judul halaman "Diary Kehamilan"**: Hardcoded `TextStyle(fontSize: 20, fontWeight: FontWeight.bold)`. Pakai `AppTypography.h2`.
- **Subtitle "Abadikan kenangan..."**: Hardcoded `TextStyle(fontSize: 11, color: Colors.grey)`. Pakai `AppTypography.bodySm.copyWith(color: AppSemanticColors.textMuted)`.
- **PDF Export button**: Icon `picture_as_pdf_outlined` — bagus, tapi padding `all(6)` terlalu kecil untuk touch target (minimal 44px).
- **Diary card shadow**: blurRadius 14, alpha 0.06 — di luar AppElevation.
- **Mood badge color** (`ColorDouce.kindaRed`):bg `0xFFF7DADC` terlalu saturated untuk badge. Pakai `alpha: 0.15` saja.

### 2.5 Checklist (`checklist_page.dart`) — SCORE: 5/10
**Yang bagus:**
- Progress card dengan gradient pink — visual hierarchy jelas
- Category tabs dengan ChoiceChip — standard dan functional

**Yang perlu ditingkatkan:**
- **Judul "Hospital Bag Checklist"**: Hardcoded `TextStyle(fontSize: 20, fontFamily: 'OpenSans')` — 2 masalah sekaligus (font salah + hardcoded).
- **Progress bar**: `LinearProgressIndicator` default Flutter styling — terlalu generik. Custom round progress atau segmented bar lebih elegant.
- **Item row**: Checkbox circle + strikethrough text = standard Material. Tambah animasi micro-interaction saat toggle (scale bounce + color transition).
- **Reset button**: `TextButton.icon` dengan label kecil (12px) — terlalu kecil. Minimal 14px.
- **Bottom padding**: Tidak ada bottom safe area padding setelah list — touch target terakhir bisa tertutup navbar.

### 2.6 Baby Names (`baby_names_page.dart`) — SCORE: 4.5/10
**Ini layar paling "biasa" di seluruh app.**

**Masalah kritis:**
- **Font OpenSans** di title ("Pencari Nama Bayi")
- **Search bar**: Plain TextField dengan `fillColor: Colors.white` dan `borderRadius: 16`. Tidak ada icon prefix yang stylistic, tidak ada shimmer/focus animation.
- **Gender chips**: ChoiceChip dengan avatar icon — standard Material, tidak ada yang special.
- **Name list items**: White rounded rectangle dengan shadow tipis, text center. Terlihat seperti list biasa.

**Rekomendasi redesign:**
```
Desain baru: Masonry/grid layout dengan nama besar (28px) + arti di bawah (12px muted)
Setiap nama dalam "pill" yang bisa di-swipe untuk favorit (heart tap)
Filter gender = segmented control horizontal (bukan chips)
Search = floating search bar dengan animasi expand
```

### 2.7 AI Chat (`ai_chat_page.dart`) — SCORE: 6/10
**Yang bagus:**
- Welcoming canvas terpusat dengan headline besar — clean
- Medical disclaimer bar — penting dan sudah ada
- Message bubbles dengan formatting bold/italic

**Yang perlu ditingkatkan:**
- **Gradient AI icon circle**: `0xFF2563EB → 0xFF7C3AED → 0xFFF43F5E` (Point 1.1)
- **Greeting text**: "Halo Bunda, apa yang ingin Anda tanyakan hari ini?" — terlalu formal/generic. Lebih personal: "Hai Bunda [nama]! Ada yang bisa Momsie bantu hari ini?"
- **Suggestion chips**: Emoji icons (Point 1.4) + shadow tipis yang tidak konsisten
- **Message input bar**: `fillColor: Color(0xFFF8FAFC)` — cool grey, tidak match warm palette app.
- **Typing indicator**: Text "Momsie AI sedang berpikir..." — gunakan animated dots (three bouncing dots) lebih elegant.

### 2.8 Birth Plan (`birth_plan_page.dart`) — SCORE: 6.5/10
**Yang bagus:**
- Header banner dengan quote — emotional connection bagus
- Accordion categories dengan selected counter badge — clear UX
- PDF export integration

**Yang perlu ditingkatkan:**
- **AppBar subtitle**: Hardcoded `TextStyle(fontSize: 12, color: Colors.grey)`
- **Counter banner**: `'$sel dari ${c.items.length} poin dipilih'` — text terlalu panjang, truncate atau ringkas jadi "X/Y dipilih"
- **Accordion chevron**: `keyboard_arrow_up/down_rounded` — standard, bisa diganti dengan smooth rotation animation
- **Checkbox**: Rounded square (6px radius) — terlalu kotak. Pakai circle (11px) untuk konsisten dengan Checklist.

### 2.9 Profile/Akun (`user_akun_page.dart`) — SCORE: 7/10
**Yang bagus:**
- Section headers dengan uppercase + tracking — clean hierarchy
- Menu items dengan icon + title + trailing — consistent pattern
- Avatar dengan camera edit overlay — standard tapi effective

**Yang perlu ditingkatkan:**
- **Section headers**: `bodySm + grey + letterSpacing 0.5` — bagus, tapi gunakan `AppSemanticColors.textMuted`
- **Menu item icons**: `Icons.*_outlined` — semua outlined. Inconsistent karena beberapa item di halaman lain pakai filled icons. Pilih satu style dan konsisten.
- **Divider**: `Colors.grey.shade200` — hardcode, gunakan semantic token
- **Sign out button**: `backgroundColor: ColorDouce.douceBase` — bagus, tapi elevation 0 terlalu flat. Tambah `level1` shadow.

### 2.10 TopBar (`topbar.dart`) — SCORE: 7.5/10
**Yang bagus:**
- Gradient pink header dengan bottom border radius — distinctive
- Avatar + greeting + name layout — clean
- Search bar dengan floating pill "Cari" — nice detail
- Notification bell dengan glassmorphism ring

**Yang perlu ditingkatkan:**
- **"Halo, Selamat Datang 👋"**: Emoji di greeting line — terlalu casual untuk medical app. Ganti dengan "Selamat pagi/siang/sore, [nama]" berdasarkan waktu.
- **Greeting text size**: `fontSize: 11` terlalu kecil. Naikkan ke 12-13px.
- **Name font**: `fontWeight: FontWeight.bold` hardcoded, tidak pakai `AppTypography`.
- **Search bar shadow**: `blurRadius: 18, offset (0,6)` — di luar AppElevation.
- **"Cari" pill badge**: `color: ColorDouce.douceBase.withValues(alpha: 0.1)` — bagus, tapi text "Cari" terlalu short. Bisa "Search" atau cukup icon saja.

---

## Part 3:系统性问题 (Systemic Issues)

### 3.1 Design System Underutilization
Hanya `user_beranda_page.dart` yang konsisten pakai `AppSpacing`, `AppRadius`, `AppElevation`. Halaman lain (`kesehatan`, `diary`, `checklist`, `baby_names`, `ai_chat`, `birth_plan`) **0%** pemakaian semantic tokens. Mereka hardcode `EdgeInsets`, `BorderRadius`, `BoxShadow` secara manual.

**Impact:** Inconsistent spacing, random shadow strengths, visual dissonance antar layar.

### 3.2 Color Token Waste
`AppSemanticColors` didefinisikan tapi hampir tidak dipakai:
- `textPrimary` (0xFF1E293B) — tidak dipakai di 4 halaman utama
- `textSecondary` (0xFF64748B) — hanya dipakai di navbar
- `textMuted` (0xFF94A3B8) — hampir tidak dipakai
- `surface`, `background` — tidak dipakai sama sekali

### 3.3 No Typography Scale Enforcement
`AppTypography` class ada tapi dipakai selektif. Banyak `TextStyle(fontSize: XX, fontWeight: YY)` langsung di widget. Ini membuat maintenance sulit dan inconsistency tinggi.

### 3.4 Mixed Elevation Philosophy
- Beberapa card pakai `AppElevation.level1/2/3` ✓
- Beberapa pakai hardcoded BoxShadow dengan nilai random ✗
- Beberapa tidak pakai shadow sama sekali ✗

---

## Part 4: Priority Action Plan

### 🔴 Phase 1: Foundation Fixes (1-2 jam)
1. **Tambah `AppSemanticColors.textDark`** (warm variant of slate) → replace semua `0xFF0F172A`
2. **Buat `AppTypography.pageTitle`** (h2 equivalent) → replace semua hardcoded title styles
3. **Fix font inconsistency** → hapus semua `fontFamily: 'OpenSans'` di user pages
4. **Create shadow helper** → function `cardShadow([level])` that returns AppElevation

### 🟠 Phase 2: Gradient & Color Pass (2-3 jam)
5. **Replace AI gradient** → warm maternal palette di AI chat page + beranda AI card
6. **Standardize shadow** → grep semua BoxShadow, map ke AppElevation levels
7. **Apply semantic colors** → textPrimary, textSecondary, textMuted di seluruh halaman

### 🟡 Phase 3: Layout & Card Elevation (3-4 jam)
8. **BabyNames redesign** → masonry grid + swipe-to-favorite + segmented filter
9. **Checklist redesign** → custom circular progress + animated toggle + better empty state
10. **Diary cards** → larger typography, better photo aspect ratio, refined badges
11. **BirthPlan** → circle checkboxes, smoother accordion animation, refined counter

### 🟢 Phase 4: Polish & Micro-interactions (2-3 jam)
12. **TopBar greeting** → time-aware greeting (pagi/siang/sore/malam)
13. **AI Chat** → animated typing dots, remove emojis from suggestions, warm input bar
14. **Navbar** → add haptic feedback on tab switch, refine FAB animation
15. **Transitions** → add page transition animations (slide + fade) for all route navigations

---

## Part 5: Target Visual Direction

**Reference points (what to aim for):**
- **Apple Health**: Clean white cards, subtle shadows, clear typography hierarchy, generous whitespace
- **Calm (meditation app)**: Soft gradients, warm palette, rounded everything, emotional connection
- **WhatToExpect**: Dense information but organized in clear sections, good use of illustrations
- **Flo Period Tracker**: Bold colors for key actions, soft pastels for info, consistent card patterns

**Momsie's unique position:** Not just a tracker, but a companion. The design should feel like a warm, trustworthy friend — not a clinical tool, not a generic AI app.

**Proposed refined palette:**
```dart
// Keep existing
ColorDouce.douceBase = #FF6972    // primary pink
ColorDouce.lightPink = #FF7A8F    // primary light
ColorDouce.veryLightPink = #FDF0FD // surface tint
ColorDouce.kindaRed = #F7DADC     // accent/warning

// Add to AppSemanticColors
textDark = #3D1F1F               // warm dark (replace 0xFF0F172A)
accentGold = #D4A574             // warm accent for highlights
softTeal = #5B9A8B               // secondary for health/doula sections
```

---

## Verification Checklist
- [ ] `flutter analyze` = 0 errors, 0 warnings
- [ ] `flutter test` = all pass
- [ ] Web preview: http://127.0.0.1:8081/ — verify visual changes
- [ ] Device test: verify all navigation still works
- [ ] No hardcoded `0xFF0F172A` remaining in user features
- [ ] No `fontFamily: 'OpenSans'` in user pages
- [ ] All shadows use AppElevation levels
- [ ] All text styles use AppTypography or semantic aliases

---

## Progress Fix #4 — AI Slop Patterns (2026-09-08)
### ✅ SELESAI
- Gradient AI blue-purple-pink → warm maternal pink di 2 file (ai_chat_page, beranda_page)
- Color(0xFF0F172A) → AppSemanticColors.textDark di 17 file (32 occurrences)
- fontFamily 'OpenSans' → AppTypography.fontFamily di 9 file (18 occurrences)
- Import design_system.dart ditambahkan ke semua file yang dirubah
- Chat page padding/margin → AppSpacing constants
- Banner carousel margin → AppSpacing.md
- flutter analyze: 0 errors
- flutter test: 15/15 PASS
- 126 design token usages terpasang di user features

### ✅ Fix #5 SELESAI — Box-Shadow Standardisasi
- 14 boxShadow di 13 file utama diganti ke AppElevation.level1/2/3 + softColor
- 47 files total changed, 0 errors, 15/15 tests pass
- Masih tersisa ~100 boxShadow hardcode di file lain (kebanyakan dynamic/conditional warna)

### ✅ Fix #6 — Slate-Gray Hardcoded (`0xFF64748B`) → textSecondary (2026-09-08)
- 10 occurrences di 6 file user features diganti ke `AppSemanticColors.textSecondary`
- flutter analyze 0 errors; flutter test 15/15 PASS; grep 0 sisa pola

### ✅ Fix #7 — Dark Gray Hardcoded (`0xFF334155`) → textDarkSecondary + Token Baru (2026-09-08)
- 9 occurrences diganti ke `AppSemanticColors.textDarkSecondary` di 6 file
- Token baru `accentGold` (#D4A574) & `softTeal` (#5B9A8B) ditambahkan ke AppSemanticColors
- flutter analyze 0 errors; flutter test 15/15 PASS; grep 0 sisa pola

### ✅ Fix #8 — textPrimary Applied to Main Page Titles (2026-09-08)
- Beranda + Diary 주요 제목에 `AppSemanticColors.textPrimary` 적용
- flutter analyze 0 errors; flutter test 15/15 PASS

### ✅ Fix #9 — BoxShadow Standardization (2026-09-08)
- 74 hardcoded BoxShadow → 29 (reduce 45)
- 45 shadow diganti ke AppElevation.level1/2/3 + softColor
- flutter analyze 0 errors; flutter test 15/15 PASS; 55 files changed
- Sisa 29: dynamic/conditional warna (tidak bisa di-standardize)

### ✅ Fix #10 SELESAI — Colors.grey + Typography Standardization (BabyNames & Checklist)
- 5x Colors.grey → AppSemanticColors.textMuted di checklist_page.dart
- 7x Colors.grey → AppSemanticColors.textMuted di baby_names_page.dart
- Title colors → AppSemanticColors.textDark di kedua halaman
- const TextStyle fix (non-const method in const constructor)
- flutter analyze 0 errors; flutter test 15/15 PASS

### ✅ Fix #11 SELESAI — Semantic Color: TopBar + Akun + Kesehatan + Search
- TopBar: greeting time-aware ("Selamat Pagi/Siang/Sore/Malam"), fontSize 11→12
- Akun: 5x Colors.grey → textMuted/textSecondary, divider → semantic
- Kesehatan: carousel dot → textMuted with alpha
- Search: shadow → AppSemanticColors.textMuted
- flutter analyze 0 errors; flutter test 15/15 PASS

### ⏳ BELUM SELESAI
- [x] ~~Sisa ~100 boxShadow hardcode~~ ✅ Fix #9 (74→29)
- [x] ~~Sisa Colors.grey di Checklist & BabyNames~~ ✅ Fix #10
- [x] ~~Sisa Colors.grey di TopBar, Akun, Kesehatan, Search~~ ✅ Fix #11
- [ ] Sisa ~100 Colors.grey di AI Chat, settings pages (Fix #12 pending)
- [ ] Verifikasi visual di device/browser

### Langkah Berikutnya
1. Commit semua perubahan
2. Device test untuk verify visual
3. (Opsional) Fix #12: Colors.grey di AI Chat + settings pages

