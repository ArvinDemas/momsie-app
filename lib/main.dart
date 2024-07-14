import 'package:douce/app/app_widget.dart';
import 'package:douce/firebase_options.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(UserController());
  runApp(const AppWidget());
}
