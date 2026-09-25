# Momsie Project Guardrails & Steering Rules

Aturan mutlak dan konvensi permanen untuk semua agen yang bekerja pada proyek Momsie (Mobile Flutter & Web Next.js).

## 1. Brand Color & Palette (MUTLAK)
- **Primary Brand Color**: `#FF6972` (`ColorDouce.douceBase`).
- **Secondary / Soft Pink**: `#FFF0F1` / `#FFE5E7`.
- **DILARANG KERAS** mengubah, mengganti, atau mendiversifikasi palette warna brand utama menjadi warna lain tanpa izin eksplisit dari user.
- Pada mobile Flutter, selalu impor dan gunakan `ColorDouce` dari `lib/shared/theme/color.dart`.
- Pada web dashboard Next.js, pastikan semua elemen primer konsisten menggunakan `#FF6972`.

## 2. Design System & Spacing Hierarchy
- Semua styling UI wajib merujuk ke `lib/shared/theme/design_system.dart`:
  - **Spacing**: Gunakan skala `AppSpacing` (`xxs: 4`, `xs: 8`, `sm: 12`, `md: 16`, `lg: 20`, `xl: 24`, `xxl: 32`, `xxxl: 48`).
  - **Radius**: Gunakan `AppRadius` (`sm: 8`, `md: 12`, `lg: 16`, `xl: 24`, `full`).
  - **Typography**: Gunakan `AppTypography` (`h1`-`h4`, `body`, `caption`).
  - **Elevation**: Gunakan `AppElevation` (`level1`-`level4`).
  - **Animation**: Gunakan `AppAnimation` (`fast: 200ms`, `normal: 300ms`, `slow: 500ms`) dengan `AppAnimation.defaultCurve`.
- **DILARANG** menggunakan angka arbitrary/hardcoded px seperti `13`, `17`, `22` di luar skala grid 4px.

## 3. Flutter State Management & Lifecycle Hygiene
- **State Management**: Gunakan GetX (`GetxController`, `Obx()`, `Get.find()`, `Get.toNamed()`). Jangan campur dengan provider/bloc lain kecuali modul lawas.
- **Dispose Mandatory**: Setiap kali membuat `AnimationController`, `TextEditingController`, `Timer`, `ScrollController`, atau `StreamSubscription`, **WAJIB** panggil `.dispose()` atau `.cancel()` di dalam method `dispose()` atau `onClose()`.
- **Input Guard**: Selalu validasi URL media dan tipe data sebelum merender widget untuk mencegah null pointer exception di runtime.

## 4. Anti-Slop & UI Aesthetics (taste-skill)
- Implementasikan micro-interaction yang halus dan responsif:
  - Tombol/Card interaktif wajib memiliki feedback visual (seperti subtle tap scale `0.88x` - `0.96x` via `_InteractiveCard`).
  - Elemen daftar/chat baru muncul dengan transisi halus (`FadeTransition` + `SlideTransition`).
- Hindari estetika kaku khas template AI default. Terapkan whitespace yang lega dan hierarki visual yang jelas.

## 5. Verifikasi & Integritas Kode
- Setiap perubahan harus didokumentasikan di file handoff atau laporan ringkas.

## 6. Bahasa Komunikasi
- Agen WAJIB selalu menggunakan **Bahasa Indonesia** yang sopan, jelas, dan profesional dalam setiap percakapan, penjelasan, dan laporan hasil kerja kepada pengguna. Dilarang menggunakan bahasa lain (seperti Mandarin/Inggris) untuk respon chat kecuali istilah teknis coding.
