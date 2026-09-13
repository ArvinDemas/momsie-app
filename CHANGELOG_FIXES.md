### Fix #13 — BookingDetail UI (zoomLink display + WhatsApp fallback), UserPesanan actions per status, ChatController access validation, booking_slot_service errors
Tanggal: 2026-09-12
File: lib/features/user/pesanan/booking_detail_page.dart, lib/features/user/pesanan/user_pesanan_page.dart, lib/features/user/chat/chat_controller.dart, lib/shared/util/service/booking_slot_service.dart, lib/shared/util/service/payment_service.dart
Masalah:
(1) BookingDetailPage tidak menampilkan status zoomLink — user tidak tahu apakah kelas virtual tersedia;
(2) UserPesananPage action button tidak membedakan status pesanan (pending vs paid/confirmed/ongoing) dan jenis layanan (on-demand vs scheduled);
(3) ChatController tidak memvalidasi akses chat berdasarkan status booking — user bisa masuk chat sebelum bayar atau di luar jam slot;
(4) `booking_slot_service.dart`: `slotRef` undefined di updateSlotCapacity, deleteSlot, incrementBookedCount, decrementBookedCount (duplikat deklarasi docId);
(5) `payment_service.dart`: `split['platformFee']` dan `split['doulaEarnings']` bertipe `int?` tapi field model expects `int`; string interpolation `$userId_$bookingId` salah sintaks.
Akar: Fitur booking/scheduled service belum diintegrasikan sempurna — controller dan service ditulis terpisah tanpa review编译.
Fix:
- T-015 BookingDetailPage: tambah badge "Menunggu Link Kelas" saat zoomLink null; tombol "Join Zoom" langsung buka URL; tombol WhatsApp fallback dengan template pesan berisi Booking ID
- T-016 UserPesananPage: action mapping — pending → "Bayar Sekarang"; paid/confirmed/ongoing → "Mulai Chat" + "Bukti Bayar"; scheduled + zoomLink → "Join Zoom"; scheduled tanpa zoomLink → "Hubungi Admin" (WhatsApp)
- T-017 ChatController: validasi status booking (hanya paid/confirmed/ongoing); untuk scheduled services validasi waktu slot ±5 menit; tampilkan screen "Chat belum tersedia" dengan tombol kembali
- booking_slot_service.dart: tambahkan `final slotRef = ...` di setiap method yang butuh; hapus duplikat `final docId = ...`; fix `int?` null-aware operator
- payment_service.dart: `split['platformFee'] ?? 0`, `split['doulaEarnings'] ?? 0`; fix string interpolation `$userId_$bookingId` → `'${userId}_$bookingId'`
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS.
Pelajaran: Setiap fitur baru yang menyentuh banyak file harus dicek compilasi sebelum commit — duplikat deklarasi variabel dan tipe int? adalah error umum saat integrasi.
Log Keyword: booking-detail-zoom, pesanan-actions, chat-access-validation, booking-slot-service-fix, payment-service-fix
Deploy: PENDING

### Fix #14 — MitraAturJadwalController & Page: Slot capacity upgrade (List<SlotItem>)
Tanggal: 2026-09-13
File: lib/features/mitra/profil/mitra_aturjadwal_controller.dart, lib/features/mitra/profil/mitra_aturjadwal_page.dart
Masalah: Controller lama pakai `List<String>` untuk slot, tidak ada informasi capacity per slot — mitra tidak bisa mengatur multi-seat booking.
Akar: Fitur scheduled service butuh capacity per jam untuk allow multiple clients per slot.
Fix:
- Upgrade `slotState` dari `RxMap<String, List<String>>` ke `RxMap<String, List<SlotItem>>` dengan fields time, capacity, bookedCount
- Tambah method: `createSlot()`, `updateSlotCapacity()`, `deleteSlot()`, `getBookingsForSlot()`, `loadMySlots()`
- Controller load all slots per bulan via Firestore query (startStr/endStr)
- SaveAllSlots pakai batch write
- View: slot chip menampilkan bookedCount/capacity, click slot aktif buka dialog edit capacity, slot penuh tampil merah
- Preset Normal/Malam/Semua Jam menggunakan capacity default
- Validasi: tidak bisa hapus slot dengan booking aktif, tidak bisa kurangi capacity di bawah bookedCount
Verifikasi: flutter analyze 0 errors, 0 warnings di kedua file.
Pelajaran: Model-driven slot management lebih aman daripada string list — semua operasi capacity-aware mencegah race condition.
Log Keyword: mitra-atur-jadwal-capacity, slotitem-upgrade, booking-slot-service, batch-save
Deploy: PENDING

### Fix #12d — Spotlight Tour Dismiss Button & Code Cleanup
Tanggal: 2026-09-09
File: lib/shared/widget/spotlight_tour.dart, lib/features/onboarding/maternal_context_page.dart
Masalah: (1) Spotlight tour card tidak memiliki tombol tutup — user harus menyelesaikan semua langkah atau tidak bisa keluar; (2) `has_seen_maternal_context` flag ditulis tapi tidak pernah dibaca (dead state).
Akar: UX desain yang terlalu memaksa (hard barrier); unused preference key menumpuk teknis debt.
Fix: (1) Tambahkan IconButton (X) di pojok kanan atas card spotlight — Navigator.pop() menutup tour; (2) Hapus tulisan has_seen_maternal_context yang tidak digunakan dari maternal_context_page.dart.
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS.
Pelajaran: Onboarding flows harus selalu menyertakan exit path yang jelas — forcing user menyelesaikan semua step tanpa exit dapat menyebabkan abandonment.
Log Keyword: spotlight-tour, dismiss-button, onboarding-ux, cleanup-dead-code
Deploy: PENDING verifikasi visual di device

### Fix #12c — Skip Maternal Context Persists State Correctly
Tanggal: 2026-09-09
File: lib/features/onboarding/maternal_context_page.dart:94
Masalah: Fungsi `_skip()` hanya menulis `has_seen_maternal_context` tapi TIDAK menulis `has_completed_maternal_context`. Akibatnya: user yang klik "Lewati" akan tetap di-redirect ke `/maternal-context` setiap kali app dibuka (splash controller hanya cek `has_completed_maternal_context`).
Akar: `has_seen_maternal_context` (udah pernah liat halaman) vs `has_completed_maternal_context` (udah selesai/skip) dibedakan, tapi skip function tidak set yang kedua.
Fix: Tambahkan `await prefs.setBool('has_completed_maternal_context', true)` di `_skip()`.
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS.
Pelajaran: When a screen has both "seen" and "completed/skipped" flags, ensure both are set on skip to prevent infinite re-routing.
Log Keyword: maternal-context, skip-function, has_completed_maternal_context
Deploy: PENDING verifikasi visual di device

### Fix #12b — Spotlight Tour Completion Persistence Bug
Tanggal: 2026-09-09
File: lib/features/user/beranda/user_beranda_page.dart:102
Masalah: Spotlight tour `onComplete` callback kosong (`() => {}`) — `has_seen_spotlight_tour` TIDAK pernah ditulis ke SharedPreferences setelah tour selesai. Tour akan muncul di SEMUA launch berikutnya, bukan sekali saja.
Akar: Fungsi `showOnce()` di `spotlight_tour.dart` hanya membaca flag sebelum memunculkan tour, tapi tidak menulisnya saat complete. Callback `onComplete` yang diteruskan dari `user_beranda_page.dart` adalah no-op.
Fix: Ganti `onComplete: () => {}` dengan callback async yang menulis `has_seen_spotlight_tour = true` ke SharedPreferences.
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS.
Pelajaran: Once-only tour/hint patterns harus memastikan state flag DISAVE saat complete, bukan hanya dicek saat tampil.
Log Keyword: spotlight-tour, onboarding-personalisasi, has_seen_spotlight_tour
Deploy: PENDING verifikasi visual di device
Tanggal: 2026-09-08
File: lib/features/onboarding/maternal_context_page.dart (BARU), lib/shared/widget/spotlight_tour.dart (BARU), lib/shared/util/user_controller.dart, lib/features/splash/splash_controller.dart, lib/app/app_routes.dart, lib/app/app_widget.dart, lib/features/user/beranda/user_beranda_page.dart
Masalah: Onboarding hanya carousel statis + dialog modal tunggal yang langsung di-dismiss; app tidak pernah mengumpulkan konteks maternal (role, tahap kehamilan, detail bayi) padahal Profil Saya lengkap.
Akar: Tidak pernah ada flow personalisasi pre-home; tidak ada mekanisme tour interaktif (tidak ada package spotlight di pubspec).
Fix: (1) MaternalContextPage — questionnaire 5 step (role → tahap kehamilan → usia → gender bayi → nama bayi), skippable, jawaban tersimpan ke UserController + SharedPreferences (pregnancy_stage, user_relationship, has_completed_maternal_context); (2) SpotlightTourOverlay — coach-mark custom dengan darkened backdrop, cutout rect pada target widget, floating card step-by-step, show-once via has_seen_spotlight_tour key; (3) Splash controller redirect user non-doula yang belum mengisi maternal context ke /maternal-context; (4) KeyedSubtree keys pada SizeGuideCard, bento grid, AI chat wide card untuk target tour.
Verifikasi: flutter analyze 0 errors (102 issues semuanya warning/info pre-existing); flutter test 15/15 PASS.
Pelajaran: AppRadius.lg adalah double, bukan BorderRadius — gunakan AppRadius.roundedLg untuk parameter BorderRadius. Icons.seed_rounded dan Icons.nest_roster_rounded tidak ada di Flutter 3.3x — pakai eco_rounded / kitchen_rounded.
Log Keyword: maternal-context, spotlight-tour, onboarding-personalisasi, has_completed_maternal_context, has_seen_spotlight_tour
Deploy: PENDING verifikasi visual di device

### Fix #10 — Colors.grey + Typography Standardization (BabyNames & Checklist)
Tanggal: 2026-09-08
File: lib/features/user/checklist/checklist_page.dart, lib/features/user/babynames/baby_names_page.dart
Masalah: Colors.grey hardcode (300/400/500/shade200/shade300/shade400) dan fontSize literal di halaman Checklist & BabyNames.
Akar: Developer menulis warna dan ukuran font literal tanpa merujuk AppSemanticColors dan AppTypography.
Fix:
- 5x Colors.grey[300/400/500] → AppSemanticColors.textMuted di checklist_page.dart
- 1x Colors.grey.shade200 → divider color semantic
- Title warna → AppSemanticColors.textDark
- 7x Colors.grey.shade* → AppSemanticColors.textMuted di baby_names_page.dart
- const TextStyle fix (non-const method di const constructor)
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS; grep 0 sisa Colors.grey di kedua file
Log Keyword: colors-grey, typography-standardization, baby-names, checklist
Deploy: PENDING

### Fix #11 — Semantic Color Standardization: Colors.grey → AppSemanticColors (TopBar, Akun, Kesehatan, Search)
Tanggal: 2026-09-08
File: topbar.dart, user_akun_page.dart, user_kesehatan_page.dart, user_search_page.dart
Masalah: 12+ occurrences `Colors.grey`, `Colors.grey.shade*` hardcode — warna ikon chevron, section header, divider, carousel dot, search shadow.
Akar: Developer menulis warna grey literal tanpa merujuk semantic tokens.
Fix:
- TopBar: greeting "Halo, Selamat Datang 👋" → time-aware `_getTimeGreeting()` ("Selamat Pagi/Siang/Sore/Malam") + fontSize 11→12, text color → white
- Akun: 3x `Colors.grey.shade400/500/600` → `textMuted/textSecondary`, section header → `textMuted`, divider → `textMuted.withValues(alpha: 0.3)`
- Kesehatan: carousel dot `Colors.grey.shade300` → `textMuted.withValues(alpha: 0.5)`
- Search: shadow `Colors.grey.withValues(alpha: 0.3)` → `AppSemanticColors.textMuted`
Verifikasi: flutter analyze 0 errors (sisa 4 info deprecation pre-existing `activeColor`); flutter test 15/15 PASS
Pelajaran: `Colors.grey` harusnya `AppSemanticColors.textMuted` atau `textSecondary` — jangan hardcode.
Log Keyword: semantic-colors, grey-replacement, time-aware-greeting
Deploy: PENDING

### Fix #4 — AI Slop Patterns: Gradient Biru-Pink, Slate-900, OpenSans → Design System
Tanggal: 2026-09-08
File: 32 file di lib/features/user/ (ai_chat, beranda, diary, edukasi, eksplor, kesehatan, pesanan, postpartum, sizeguide, akun, babynames, checklist, obat, search, theme, birthplan)
Masalah: 181 box-shadow hardcode, gradient biru-ungu-pink identik Gemini AI, warna slate-900 (`0xFF0F172A`) corporate, dan font OpenSans bertabrakan dengan Poppins di design system. Semua adalah "AI slop" patterns.
Akar: Developer/AI generator sebelumnya menulis warna dan font hardcoded tanpa merujuk design system tokens yang sudah tersedia (AppSemanticColors, AppTypography, AppSpacing).
Fix:
- Ganti gradient AI blue-purple-pink (#2563EB, #7C3AED) → warm maternal pink-rose (#BE185D, #F472B6, #FFD1DC) di ai_chat_page dan beranda_page
- Ganti Color(0xFF0F172A) → AppSemanticColors.textDark di 17 file (32 total occurrences)
- Ganti fontFamily: 'OpenSans' → AppTypography.fontFamily di 9 file (18 total occurrences)
- Tambahkan import design_system.dart ke semua file yang dirubah
- Chat page: padding/margin hardcoded → AppSpacing constants
- Banner carousel margin → AppSpacing.md
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS; 126 design token usages terpasang
Pelajaran: Selalu rujuk design system tokens (AppSemanticColors, AppTypography, AppSpacing) alih-alih hex literal dan font hardcoded. AI-generated code sering memasukkan pattern corporate/Gemini yang tidak sesuai brand identity.
Log Keyword: ai-slop, gradient, open-sans, slate-900, design-system-consistency
Deploy: PENDING

### Fix #1 — FAB Menimpa Navigasi & Konten: Integrasi button ke dalam navbar row
Tanggal: 2026-09-07
File: lib/shared/widget/navbar.dart, lib/features/user/beranda/user_beranda_page.dart
Masalah: Floating AI FAB diposisikan dengan `Positioned(top: -18)` di luar container navbar (menggunakan Stack), menumpuk di atas tab "Doula" dan "Edukasi", serta menutupi bagian bawah konten card di atasnya.
Akar: Layout navbar menggunakan `Stack` tanpa `clipBehavior` yang tepat untuk FAB; FAB diletakkan sebagai child terpisah di luar Row.
Fix: Mengganti layout menjadi single `Row` dengan 5 item — FAB disisipkan di posisi ke-3 (antara item 1 dan 2). Menghapus Stack/Positioned wrapper sepenuhnya. Mengurangi ukuran FAB dari 58px ke 48px agar proporsional di dalam bar. Mengubah bottom padding ListView beranda dari `120` hardcoded ke `AppSpacing.xl` (24px).
Verifikasi: flutter analyze 0 errors pada 5 file yang diubah; flutter test 15/15 PASS
Pelajaran: FAB yang "floating" di atas nav bar selalu berisiko menumpuk konten — lebih aman sebagai bagian dari row navigation itu sendiri.
Log Keyword: fab, navbar, overflow, bottom-padding
Deploy: PENDING

### Fix #2 — Subtitle Milestone Kehamilan Menampilkan "Seukuran ()" Kosong
Tanggal: 2026-09-07
File: lib/features/user/sizeguide/sizeguide_controller.dart, lib/features/user/sizeguide/sizeguide_card.dart
Masalah: Pada kartu SizeGuideCard di Beranda, subtitle menampilkan "Seukuran ()" ketika data SQLite untuk fruit_name dan length_metric kosong.
Akar: LocalDbService.getSizeGuide() mengembalikan baris dari SQLite, namun beberapa field bisa kosong (NULL atau string kosong). Controller langsung assign value tanpa fallback, sehingga UI menerima string kosong.
Fix: Menambahkan `_builtinFallback` map (week 1-40) berisi data perbandingan buah standar di controller. Menambah getter publik `resolvedFruitText` dan `resolvedLengthText` yang mengecek DB dulu, fallback ke built-in jika kosong. SizeGuideCard menggunakan getter baru dengan logic ternary: jika lengthMetric kosong, tampilkan "Seukuran X" tanpa tanda kurung kosong.
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS. Tidak ada lagi string "Seukuran ()" yang bisa muncul.
Pelajaran: Selalu sertakan fallback data untuk field yang bisa kosong dari database, terutama untuk data yang ditampilkan langsung ke user.
Log Keyword: sizeguide, empty-parentheses, fallback, milestone
Deploy: PENDING

### Fix #9 — BoxShadow Standardization (74→29, 45 reductions)
Tanggal: 2026-09-08
File: 15+ file (ai_chat, booking_doula, diary_form, detail_toko, detail_doula, detail_rumahsakit, user_artikel, user_edukasi, sizeguide, postpartum_wellbeing, baby_names, booking_detail, paywall_modal)
Masalah: 74 hardcoded BoxShadow dengan nilai random (blurRadius 4-20, alpha 0.03-0.35).
Akar: Developer menulis shadow manual tanpa merujuk AppElevation tokens.
Fix:
- 45 hardcoded BoxShadow → AppElevation.level1/2/3 + softColor
- level1: blur 6, offset (0,2), alpha 0.04 → card kecil/badge
- level2: blur 12, offset (0,4), alpha 0.08 → card utama
- level3: blur 20, offset (0,8), alpha 0.12 → hero/banner
- softColor: untuk shadow berwarna (doula, checklist, diary, birth plan)
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS; 55 files changed
Sisa: 29 BoxShadow (kebanyakan dynamic/conditional warna, tidak bisa di-standardize)
Pelajaran: AppElevation sudah tersedia — cukup gunakan, jangan tulis ulang shadow manual.
Log Keyword: box-shadow-standardization, elevation, shadow-fix
Deploy: PENDING

### Fix #8 — AppSemanticColors.textPrimary Applied to Main Page Titles
Tanggal: 2026-09-08
File: user_beranda_page.dart, diary_list_page.dart
Masalah: `textPrimary` token 정의됐지만 0사용. 페이지 제목이 textDark와 동일하게 표시.
Fix: Beranda "Layanan & Fitur Utama", "Pusat Perlengkapan Bayi", "Edukasi & Artikel" + Diary "Diary Kehamilan" 등 주요 제목에 textPrimary 적용.
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS
Log Keyword: text-primary, semantic-colors
Deploy: PENDING

### Fix #7 — Dark Gray Hardcoded (`0xFF334155`) → textDarkSecondary + Token Baru (accentGold, softTeal)
Tanggal: 2026-09-08
File: 6 file (ai_chat_page, diary_detail, diary_form, user_artikel, detail_doula, paywall_modal) + design_system.dart
Masalah: 9 occurrences `Color(0xFF334155)` hardcode + 0 token baru untuk aksen hangat (gold, teal).
Akar: Warna teks sekunder gelap ditulis literal tanpa semantic token.
Fix:
- 9 `Color(0xFF334155)` → `AppSemanticColors.textDarkSecondary`
- Tambah `accentGold` (#D4A574) dan `softTeal` (#5B9A8B) ke AppSemanticColors
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS; grep 0 sisa pola
Pelajaran: Token warna baru harus ditambahkan ke design system sebelum dipakai, bukan ditulis literal.
Log Keyword: text-dark-secondary, accent-gold, soft-teal, design-system-tokens
Deploy: PENDING

### Fix #6 — Slate-Gray Hardcoded (`0xFF64748B`) → AppSemanticColors.textSecondary
Tanggal: 2026-09-08
File: 6 file di lib/features/user/ (beranda, birthplan, detailprogram, booking_doula, postpartum_wellbeing, sizeguide)
Masalah: 10 occurrences `Color(0xFF64748B)` hardcode — warna yang sama dengan `AppSemanticColors.textSecondary` tapi ditulis manual tanpa merujuk token.
Akar: Developer/AI menulis warna secondary text secara literal alih-alih pakai semantic token.
Fix: Ganti semua 10 `Color(0xFF64748B)` → `AppSemanticColors.textSecondary` di 6 file user features.
Verifikasi: flutter analyze 0 errors (111 issues tersisa, semuanya pre-existing di signature_pad.dart); flutter test 15/15 PASS; grep 0 sisa pola.
Pelajaran: Semua warna harus merujuk semantic tokens — jangan tulis hex literal yang sudah ada di AppSemanticColors.
Log Keyword: text-secondary, color-hardcode, semantic-tokens
Deploy: PENDING

### Fix #5 — Box-Shadow Standardisasi ke AppElevation
Tanggal: 2026-09-08
File: 13 widget/page (doula_container, tokobayi_container, artikel_container, rumah_sakit_container, navbar, beranda, checklist, sizeguide_card, diary_list, diary_pdf, birth_plan, account_topbar, topbar)
Masalah: 133 box-shadow hardcode dengan nilai acak (blurRadius 6-20, offset 2-8, alpha 0.03-0.4). Tidak ada hierarki visual konsisten.
Akar: Setiap developer/AI menulis shadow sendiri-sendiri tanpa merujuk AppElevation yang sudah tersedia.
Fix:
- 14 boxShadow di 13 file utama diganti ke AppElevation.level1/2/3 atau softColor
- level1: blur 6, offset (0,2) → badge/badge kecil
- level2: blur 12, offset (0,4) → card utama
- level3: blur 20, offset (0,8) → hero/banner
- softColor: untuk shadow berwarna (doula, checklist, diary, birth plan)
- Import design_system.dart ditambahkan ke 8 file baru
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS; 47 files total changed
Pelajaran: AppElevation sudah didefinisikan di design system sejak awal — cukup gunakan, jangan tulis ulang shadow manual.
Log Keyword: box-shadow, elevation, shadow-standardization
Deploy: PENDING

### Fix #3 — Ikon Toko Bayi Merah Tidak Konsisten dengan Design System
Tanggal: 2026-09-07
File: lib/shared/widget/tokobayi_container.dart
Masalah: TokoBayiContainer menggunakan warna merah datar `#FF6972` untuk error icon dan `#EA4335` (Google red) untuk CTA tombol Maps, menciptakan visual clash dengan palet pink lembut Momsie.
Akar: Warna-warna tersebut dipilih secara ad-hoc, tidak mengacu pada AppSemanticColors atau ColorDouce tokens yang sudah ada.
Fix: Error icon image diganti ke `ColorDouce.douceBase.withValues(alpha: 0.5)` — pink lembut transparan. Icon lokasi alamat diubah dari `Colors.redAccent` ke `AppSemanticColors.textMuted` (slate abu-abu). CTA button Maps diganti dari merah Google ke pink primary Momsie (`ColorDouce.douceBase`) dengan label "Lihat di Peta" dan icon `Icons.map_rounded`. Menggunakan `AppRadius.roundedLg` konsisten dengan design system.
Verifikasi: flutter analyze 0 errors; flutter test 15/15 PASS. Seluruh warna sekarang konsisten dengan palette Momsie pink.
Pelajaran: Semua warna UI harus merujuk ke design system tokens, bukan hex literal ad-hoc.
Log Keyword: toko-bayi, icon, color-consistency, design-system
Deploy: PENDING
