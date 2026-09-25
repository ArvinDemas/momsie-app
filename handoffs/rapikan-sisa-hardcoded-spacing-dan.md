# Rapikan Sisa Hardcoded Spacing & Alignment
Status: ✅ SELESAI · Service: UI Polish · Diperbarui: 2026-09-07 08:00

## Sedang dikerjakan
SELESAI — semua task di tasks.md tuntas.

## Status terakhir
- `user_beranda_page.dart`: 17 hardcoded nilai diganti token design system
- `user_akun_page.dart`: ~30 hardcoded nilai diganti token design system
- Import `design_system.dart` ditambahkan ke akun page
- `flutter analyze` bersih (0 errors; 4 pre-existing deprecation infos, 1 pre-existing unused method warning)
- `flutter test` 15/15 PASS

## Keputusan penting
- `width: 48` di header akun page tetap hardcoded (struktural balance spacer, bukan spacing scale)
- `borderRadius.circular(100)` avatar tetap hardcoded (semantic, bukan scale value)
- `padding: all(6)` camera button tetap hardcoded (struktural kecil)
- Semua dialog `borderRadius.circular(20)` → `AppRadius.roundedLg`
- `_buildMenuItem` alignment: icon spacing `SizedBox(width: 14)` → `AppSpacing.sm`

## Langkah berikutnya
Tidak ada — pekerjaan lengkap.

## Jangan lakukan
Jangan ubah nilai-nilai struktural yang sengaja dipertahankan (48px, 100px, 6px).
