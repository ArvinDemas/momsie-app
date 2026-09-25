# UI/UX Micro-Animation & Padding Enhancement
Status: BERJALAN · Service: mobile (chat + beranda) · Diperbarui: 2026-09-07

## Sedang dikerjakan
Implementasi micro-animation dan padding elegan pada Chat Doula & Beranda halaman.

## Status terakhir
✅ `chat_page.dart`:
- Bubble pesan baru: Fade + slide animation saat muncul (StatefulWidget + AnimationController)
- Send button & Mic button: Tap feedback scale animation (0.88x)
- Padding bubble: Horizontal 12px → AppSpacing.sm (12), Vertical 9px → AppSpacing.xs (8)
- Import design_system.dart ditambahkan

✅ `user_beranda_page.dart`:
- Semua section spacing: hardcoded px → AppSpacing constants
- Bento cards: tap feedback scale animation via _InteractiveCard wrapper
- Import design_system.dart ditambahkan

⚠️ TODO tersisa:
- Banner carousel margin masih hardcoded 20 → perlu AppSpacing.md
- Ukuran font di section titles masih hardcoded 18 → AppTypography.h3

## Keputusan penting
- Gunakan StatefulWidget + AnimationController untuk micro-animations (bukan simple setState)
- _InteractiveCard widget reusable untuk semua card dengan tap feedback
- AppSpacing.scale digunakan konsisten di seluruh page

## Langkah berikutnya
1. Ganti hardcoded spacing tersisa di chat_page.dart dan beranda_page.dart
2. Update banner carousel margin ke AppSpacing
3. Sinkronisasi warna brand web dashboard ke #FF6972 (mobile)
4. Review halaman user_akun_page.dart untuk konsistensi

## Jangan lakukan
- Jangan hapus AnimationController yang sudah ada (sudah proper dispose)
- Jangan ubah struktur GetX controller (hanya UI changes)

## Log Keyword
Fix #1: chat_page micro-animation | Fix #2: beranda_page padding scale
