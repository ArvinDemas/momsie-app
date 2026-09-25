# Audit UX/UI Beranda — 3 Temuan Utama
Status: BERJALAN · Service: user/beranda · Diperbarui: 2026-09-07 15:50

## Sedang dikerjakan
Audit UX/UI oleh design critique menemukan 3 masalah di Beranda. Fix #1 (FAB), #2 (empty milestone), #3 (red icon) sudah diterapkan di code dan terverifikasi flutter analyze 0 errors + 15/15 tests PASS. Belum ada build/release yang dijalankan di device asli.

## Status terakhir
- ✅ Fix #1: FAB integrated ke navbar row (navbar.dart + user_beranda_page.dart)
- ✅ Fix #2: Fallback data untuk milestone kosong (sizeguide_controller.dart + sizeguide_card.dart)
- ✅ Fix #3: Warna icon toko bayi disesuaikan dengan design system (tokobayi_container.dart)
- ⏳ Build web masih berjalan di background untuk visual verification
- ⏳ Belum deploy ke device/app store

## Keputusan penting
- FAB dipindahkan dari Stack/Positioned ke dalam Row navbar sebagai item ke-3 — lebih ergonomis, tidak menumpuk konten
- Fallback hardcoded week 1-40 di controller karena SQLite mungkin belum terisi untuk semua minggu
- Semua warna UI TokoBayiContainer sekarang merujuk ke `ColorDouce.douceBase` alih-alih hex literal ad-hoc

## Langkah berikutnya
1. Tunggu build web selesai → verifikasi visual di browser
2. Jalankan di device fisik (jika tersedia) untuk konfirmasi FAB tidak menumpuk
3. Update CHANGELOG status ke ✅ LIVE setelah deploy
4. Hapus file handoff ini setelah deploy verifikasi

## Jangan lakukan (jebakan yang sudah ditemukan)
- Jangan kembalikan FAB ke posisi floating asli — merusak layout
- Jangan hapus fallback data di controller — SQLite bisa kosong di device baru
- Jangan gunakan warna merah literal di toko bayi lagi — tidak konsisten brand
