import 'package:douce/app/app_widget.dart';
import 'package:douce/bindings.dart';
import 'package:douce/firebase_options.dart';
import 'package:douce/shared/util/service/app_config_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  Get.put(AppConfigService(), permanent: true);

  // Handle deep link untuk email verification
  await _handleInitialLink();

  runApp(AppWidget(
    initialBinding: AllBindings(),
  ));
}

/// Handle deep link saat aplikasi pertama kali dibuka (cold start)
Future<void> _handleInitialLink() async {
  // getInitialLink removed — handled by Flutter deep link system instead
}

/// Process email verification link dari deep link
Future<void> _processLink(String link) async {
  if (!link.contains('verifyEmail') && !link.contains('emailAction')) return;

  try {
    // Langsung apply action ke Firebase Auth
    final auth = FirebaseAuth.instance;
    final urlWithoutQuery = link.split('?').first;
    await auth.applyActionCode(urlWithoutQuery);
    debugPrint('Email verified via deep link!');
  } catch (e) {
    debugPrint('Deep link error: $e');
  }
}

/// Listen untuk dynamic link / app link saat aplikasi sudah berjalan
void listenForLinks() {
  // Untuk handling link setelah app berjalan (hot restart)
  // Firebase Auth sudah menangani ini melalui getInitialLink
}
