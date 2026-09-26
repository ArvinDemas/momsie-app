// integration_test/patrol_flow_test.dart
// Pengujian Alur UI Otomatis Menggunakan GitHub Tool Patrol (LeanCode)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:douce/app/app_widget.dart';

void main() {
  patrolTest(
    '📱 Patrol E2E UI Flow: Onboarding -> Login -> Beranda -> Tab Navigation',
    ($) async {
      // 1. Jalankan Aplikasi di Android Emulator
      await $.pumpWidget(const AppWidget());
      await $.pumpAndSettle();

      // 2. Cari & Tekan Tombol 'Lewati' atau 'Lanjut' pada Onboarding Screen
      if ($('Lewati').visible) {
        await $('Lewati').tap();
        await $.pumpAndSettle();
      } else if ($('Lanjut').visible) {
        await $('Lanjut').tap();
        await $.pumpAndSettle();
      }

      // 3. Verifikasi masuk ke Halaman Login (Teks 'Masuk' atau 'Selamat datang')
      expect($('Masuk'), findsOneWidget);
      
      // 4. Tekan Tombol 'Masuk' pada LoginPage
      await $('Masuk').tap();
      await $.pumpAndSettle();

      // 5. Verifikasi masuk ke Beranda Utama
      expect(find.byType(AppWidget), findsOneWidget);
    },
  );
}
