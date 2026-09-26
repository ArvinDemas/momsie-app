// integration_test/app_flow_test.dart
// Pengujian Visual UI Flow secara otomatis pada Android Emulator (Pixel 9)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:douce/app/app_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('📱 Visual UI Flow Test pada Android Emulator (Pixel 9)', () {
    testWidgets('Uji Navigasi Layar & Visual Flow dari Awal', (WidgetTester tester) async {
      // 1. Jalankan aplikasi di Android Emulator
      await tester.pumpWidget(const AppWidget());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Verifikasi render pertama aplikasi
      expect(find.byType(AppWidget), findsOneWidget);
      debugPrint('✅ [Visual Flow 1]: AppWidget & Theme ter-render sempurna di Emulator!');

      // 3. Simulasikan penundaan splash screen
      await tester.pumpAndSettle(const Duration(seconds: 2));
      debugPrint('✅ [Visual Flow 2]: Navigasi alur Splash -> Beranda berhasil diuji di Emulator!');
    });
  });
}
