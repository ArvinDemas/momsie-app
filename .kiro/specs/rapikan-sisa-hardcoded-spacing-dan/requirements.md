# Rapikan Sisa Hardcoded Spacing & Alignment

## Goal
Ganti semua nilai hardcoded spacing, typography size, dan radius di
`user_beranda_page.dart` serta `user_akun_page.dart` dengan token dari
`AppSpacing`, `AppTypography`, `AppRadius`, dan `AppElevation` yang ada di
`lib/shared/theme/design_system.dart`. Rapikan juga alignment kolom icon–title
pada list tile di akun page.

## Acceptance Criteria

### user_beranda_page.dart
- Tidak ada `SizedBox(width/height: <angka>)` lagi yang bisa digantikan token spacing
- Tidak ada `padding: const EdgeInsets.all(<angka>)` atau `EdgeInsets.symmetric` yang angkanya = 4, 8, 12, 16, 20, 24
- Tidak ada `fontSize:` inline yang nilainya = 11, 12, 14, 16
- Tidak ada `borderRadius: BorderRadius.circular(<angka>)` yang nilainya = 8, 12, 16, 24
- Semua `TextStyle` tanpa style name diganti ke `AppTypography.*` yang sesuai
- Import `design_system.dart` sudah ada (sudah ada sebelumnya)

### user_akun_page.dart
- Tidak ada `SizedBox(width/height: <angka>)` lagi yang bisa digantikan token spacing
- Tidak ada `padding: const EdgeInsets.all(<angka>)` atau `EdgeInsets.symmetric/horizontal/vertical` yang angkanya = 4, 8, 12, 16, 20, 24, 32
- Tidak ada `fontSize:` inline yang nilainya = 11, 12, 13, 14, 15, 16, 20
- Tidak ada `borderRadius: BorderRadius.circular(<angka>)` yang nilainya = 8, 10, 12, 20, 26
- Semua `TextStyle` tanpa style name diganti ke `AppTypography.*` yang sesuai
- Tambahkan `import 'package:douce/shared/theme/design_system.dart';`
- Alignment kolom icon–title pada `_buildMenuItem`: icon mendapat leading padding
  `AppSpacing.sm`, sehingga baseline teks icon sejajar dengan baseline teks title
- Divider spacing antar item konsisten: tinggi row tetap sama, hanya padding
  dalam yang berubah

### Umum
- `flutter analyze` bersih (0 issues) pada kedua file
- Tidak ada perubahan layout visual yang terlihat (hanya penggantian constant)
- `flutter test` tetap 15/15 PASS
