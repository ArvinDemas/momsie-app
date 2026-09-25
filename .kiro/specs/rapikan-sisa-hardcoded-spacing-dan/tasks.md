# Tasks — Rapikan Sisa Hardcoded Spacing & Alignment

## Phase 1: user_beranda_page.dart

### Task 1 — Banner fallback text (lines 356–375)
- `fontSize: 16, fontWeight: bold, color: white` → replace dengan const TextStyle yang relevan (atau `AppTypography.h4` dengan `color: Colors.white`)
- `SizedBox(height: 6)` → `SizedBox(height: AppSpacing.xxs)`
- `fontSize: 11` → `AppTypography.caption`

### Task 2 — Dots indicator (lines 390–400)
- `SizedBox(height: 10)` → `SizedBox(height: AppSpacing.xxs)`
- `EdgeInsets.symmetric(horizontal: 3)` → tetap 3 (di luar scale; nilai kecil struktural)

### Task 3 — _bentoCardWide: padding & icon container (lines 548–568)
- `padding: EdgeInsets.all(16)` → `AppSpacing.cardPadding`
- `padding: EdgeInsets.all(12)` di icon container → `const EdgeInsets.all(AppSpacing.xs)`
- `blurRadius: 12` di shadow → tetap (bukan spacing scale value)

### Task 4 — _bentoCardWide: inner text styles (lines 580–595)
- `fontSize: 14, fontWeight: bold, color: white` → `AppTypography.h4` dengan `color: Colors.white`
- `SizedBox(height: 2)` → tetap 2 (di bawah scale; struktural)
- `fontSize: 11, color: white70` → `AppTypography.caption` dengan `color: Colors.white70`

### Task 5 — _bentoCardWide: chevron icon (line 600)
- `size: 24` → tetap (icon size, bukan spacing)

### Task 6 — _buildBentoGrid: row/column gaps
- Semua `SizedBox(height/width: AppSpacing.sm)` sudah pakai token — verifikasi tidak ada yang terlewat

## Phase 2: user_akun_page.dart

### Task 7 — Tambah import design_system
Tambahkan `import 'package:douce/shared/theme/design_system.dart';` setelah import color.dart (baris 5).

### Task 8 — ListView padding & section gaps
- Line 27: `EdgeInsets.symmetric(horizontal: 20, vertical: 16)` → `AppSpacing.pagePaddingWide`
- Lines 31, 101, 148, 201, 227, 251: `SizedBox(height: 24)` → `SizedBox(height: AppSpacing.xxl)`
- Lines 279, 328: `SizedBox(height: 32)` → `SizedBox(height: AppSpacing.xxxl)`

### Task 9 — Header section (lines 342–410)
- `size: 28` pada close icon → tetap (icon size)
- `fontSize: 20, fontWeight: bold` di "Profil Saya" → `AppTypography.h2`
- `fontSize: 13, color: grey.shade600` di username subtitle → `AppTypography.bodySm` dengan color
- `SizedBox(height: 20)` → `SizedBox(height: AppSpacing.sm)`
- `SizedBox(width: 48)` → tetap (struktural balance)
- Avatar container: `width/height: 96` → tetap (semantic ukuran avatar)
- Camera button: `padding: EdgeInsets.all(6)` → tetap (struktural)
- `borderRadius: BorderRadius.circular(100)` → tetap ( Semantic untuk avatar)

### Task 10 — Section header (lines 473–486)
- `padding: EdgeInsets.only(bottom: 8, top: 8)` → `EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.xs)`
- `fontSize: 13, fontWeight: w600, color: grey, letterSpacing: 0.5` → buat const `AppTypography.sectionHeader` atau gunakan `AppTypography.bodySm` dengan weight override

### Task 11 — _buildMenuItem alignment fix
- `borderRadius: BorderRadius.circular(10)` → `AppRadius.roundedSm`
- `padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4)` → `EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xxs)`
- `SizedBox(width: 14)` antara icon & text → `SizedBox(width: AppSpacing.sm)`
- Text style `fontSize: 15, fontWeight: w500, color: black87` → `AppTypography.bodyMd` dengan weight override

### Task 12 — Trailing text styles di semua _buildMenuItem calls
Ganti semua `fontSize: 14` + warna terkait ke:
- `color: Colors.black54, fontSize: 14` → `AppTypography.bodyMd` dengan color override
- `color: Colors.black87, fontWeight: bold` → `AppTypography.h4`

### Task 13 — Sign out button
- `height: 52` → tetap (semantic button height)
- `borderRadius: BorderRadius.circular(26)` → `AppRadius.roundedMd`
- `fontSize: 16, fontWeight: bold` → `AppTypography.h4`

### Task 14 — Footer text
- `fontSize: 11, color: grey.shade500` → `AppTypography.caption` dengan color
- `SizedBox(height: 4)` → `SizedBox(height: AppSpacing.xxs)`

### Task 15 — Dialog border radius konsistensi
Semua `BorderRadius.circular(20)` di dialog → `AppRadius.roundedLg`

### Task 16 — Dialog inner spacing
- `SizedBox(height: 12)` di calculator modal → `SizedBox(height: AppSpacing.sm)`
- `padding: EdgeInsets.all(12)` → `AppSpacing.cardPaddingSm`
- `SizedBox(width: 8)` → `SizedBox(width: AppSpacing.xs)`

### Task 17 — SimpleDialog options
- `padding: EdgeInsets.symmetric(vertical: 8)` → `EdgeInsets.symmetric(vertical: AppSpacing.xs)`
- `SizedBox(width: 12)` → `SizedBox(width: AppSpacing.sm)`
- `fontSize: 16` → `AppTypography.h4`

## Phase 3: Verify

### Task 18 — flutter analyze
Jalankan `flutter analyze lib/features/user/beranda/user_beranda_page.dart lib/features/user/acun/user_akun_page.dart` → harus 0 issues.

### Task 19 — flutter test
Jalankan `flutter test` → harus 15/15 PASS.

### Task 20 — Spot check
Pastikan tidak ada nilai 4/8/12/16/20/24/32 yang masih hardcoded sebagai angka literal di kedua file target.
