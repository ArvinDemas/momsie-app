import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/app/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  RxBool showPassword = false.obs;
  RxBool isDoulaLogin = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> tryLogin(String email, String password) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Kolom Kosong',
        'Mohon isi email dan password',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Doula Demo Pre-configured Accounts (Instant Test Login)
    final List<String> testDoulaEmails = [
      'anastasia.doula@momsie.id',
      'dewi.doula@momsie.id',
      'laily.doula@momsie.id',
    ];

    if (testDoulaEmails.contains(trimmedEmail.toLowerCase())) {
      final UserController userController = Get.find<UserController>();
      final doulaObj = DummyData.doulas.firstWhere(
        (d) => d.email.toLowerCase() == trimmedEmail.toLowerCase(),
        orElse: () => DummyData.doulas.first,
      );
      userController.setUser(
        doulaObj.name,
        trimmedEmail,
        doulaObj.uid,
        doulaObj.image,
        true, // isDoula
      );
      userController.setDoula(
        doulaObj.name,
        doulaObj.alamat,
        'Daerah Istimewa Yogyakarta',
        doulaObj.biografi,
        doulaObj.image,
        doulaObj.jenisKelamin,
        '3404123456780001',
      );
      Get.offAllNamed(AppRoutes.mitra);
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot userDoc = await firestore
          .collection('user')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        Get.snackbar(
          'Login Gagal',
          'Data pengguna tidak ditemukan. Hubungi dukungan.',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final UserController userController = Get.find<UserController>();
      userController.setUser(
        userDoc['username'],
        email,
        userCredential.user!.uid,
        userDoc['image'],
        userDoc['isDoula'],
      );

      // Cek email verified sebelum masuk
      if (!userCredential.user!.emailVerified) {
        Get.offNamed(AppRoutes.verifyEmail);
        return;
      }

      final bool isDoulaRole = isDoulaLogin.value || (userDoc['isDoula'] == true);
      if (isDoulaRole) {
        if (userDoc['isDoula'] != true) {
          await firestore.collection('user').doc(userCredential.user!.uid).update({'isDoula': true});
        }
        final DocumentSnapshot mitraData = await firestore
            .collection('mitra')
            .doc(userCredential.user!.uid)
            .get();
        if (mitraData.exists) {
          userController.setDoula(
            mitraData['name'] ?? userDoc['username'],
            mitraData['alamat'] ?? 'DIY Yogyakarta',
            mitraData['kotaProvinsi'] ?? 'Daerah Istimewa Yogyakarta',
            mitraData['biografi'] ?? 'Mitra Doula Profesional Momsie',
            mitraData['image'] ?? userDoc['image'] ?? '',
            mitraData['jenisKelamin'] ?? 'Perempuan',
            mitraData['nik'] ?? '3404123456780001',
          );
        } else {
          final newMitraData = {
            'name': userDoc['username'] ?? 'Mitra Doula',
            'email': email,
            'alamat': 'DIY Yogyakarta',
            'kotaProvinsi': 'Daerah Istimewa Yogyakarta',
            'biografi': 'Mitra Doula Profesional Momsie',
            'image': userDoc['image'] ?? '',
            'jenisKelamin': 'Perempuan',
            'nik': '3404123456780001',
            'isAvailable': true,
            'rating': 5.0,
          };
          await firestore.collection('mitra').doc(userCredential.user!.uid).set(newMitraData);
          userController.setDoula(
            userDoc['username'] ?? 'Mitra Doula',
            'DIY Yogyakarta',
            'Daerah Istimewa Yogyakarta',
            'Mitra Doula Profesional Momsie',
            userDoc['image'] ?? '',
            'Perempuan',
            '3404123456780001',
          );
        }
        Get.offAllNamed(AppRoutes.mitra);
      } else {
        Get.offAllNamed(AppRoutes.user);
      }
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        'Email atau password salah / tidak terdaftar.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
  }

  Future<void> tryGoogleLogin() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Safely disconnect previous session if any without throwing
      try {
        await googleSignIn.signOut();
      } catch (e) {
        debugPrint('[GoogleSignIn] signOut ignored error: $e');
      }

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled Google sign-in dialog
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      if (userCredential.user == null) return;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final email = userCredential.user!.email;

      // 1. Search user document by UID or by email safely
      DocumentSnapshot? userDoc;
      try {
        userDoc = await firestore
            .collection('user')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists && email != null && email.isNotEmpty) {
          final queryUser = await firestore
              .collection('user')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();
          if (queryUser.docs.isNotEmpty) {
            userDoc = queryUser.docs.first;
          }
        }
      } catch (e) {
        debugPrint('[FirestoreUserDoc] Error: $e');
      }

      // 2. Search mitra document by UID or by email safely
      DocumentSnapshot? mitraDoc;
      try {
        final mitraByUid = await firestore
            .collection('mitra')
            .doc(userCredential.user!.uid)
            .get();

        if (mitraByUid.exists) {
          mitraDoc = mitraByUid;
        } else if (email != null && email.isNotEmpty) {
          final mitraByEmail = await firestore
              .collection('mitra')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();
          if (mitraByEmail.docs.isNotEmpty) {
            mitraDoc = mitraByEmail.docs.first;
          }
        }
      } catch (e) {
        debugPrint('[FirestoreMitraDoc] Error: $e');
      }

      final bool wantDoula = isDoulaLogin.value;
      final bool isRegisteredDoula = mitraDoc != null ||
          (userDoc != null && userDoc.exists && (userDoc.data() as Map<String, dynamic>?)?['isDoula'] == true) ||
          (email == 'adnaryama1@gmail.com');
      final bool isDoula = wantDoula || isRegisteredDoula;

      String username = userCredential.user!.displayName ?? 'User';
      String? image = userCredential.user!.photoURL;

      if (mitraDoc != null && mitraDoc.exists) {
        final data = mitraDoc.data() as Map<String, dynamic>?;
        if (data != null && data['name'] != null && data['name'].toString().isNotEmpty) {
          username = data['name'];
        }
      } else if (userDoc != null && userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;
        if (data != null && data['username'] != null) {
          username = data['username'];
        }
      }

      // Special check for Arvin Demas Naryama
      if (email == 'adnaryama1@gmail.com') {
        username = 'Arvin Demas Naryama';
      }

      // Save/update user doc safely
      try {
        await firestore.collection('user').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'image': image,
          'uid': userCredential.user!.uid,
          'isDoula': isDoula,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('[SaveUserDoc] Error: $e');
      }

      final UserController userController = Get.find<UserController>();
      userController.setUser(
        username,
        email ?? '',
        userCredential.user!.uid,
        image ?? '',
        isDoula,
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (isDoula) {
        final String doulaName = (email == 'adnaryama1@gmail.com' || username.contains('Arvin'))
            ? 'Arvin Demas Naryama'
            : username;

        final mitraDataToSave = {
          'name': doulaName,
          'email': email,
          'uid': userCredential.user!.uid,
          'alamat': 'DIY Yogyakarta',
          'kotaProvinsi': 'Daerah Istimewa Yogyakarta',
          'biografi': 'Mitra Doula Profesional berpengalaman dalam pendampingan kehamilan, pertolongan fisik & emosional persalinan aman, relaksasi kontraksi, serta pendampingan pasca melahirkan.',
          'image': image ?? '',
          'jenisKelamin': 'Laki-laki',
          'nik': '3404123456780001',
          'isAvailable': true,
          'rating': 5.0,
        };

        // Save under user's UID safely (prevent permission denied crash)
        try {
          await firestore.collection('mitra').doc(userCredential.user!.uid).set(mitraDataToSave, SetOptions(merge: true));
        } catch (e) {
          debugPrint('[SaveMitraDoc] Error: $e');
        }

        userController.setDoula(
          doulaName,
          'DIY Yogyakarta',
          'Daerah Istimewa Yogyakarta',
          'Mitra Doula Profesional Momsie',
          image ?? '',
          'Laki-laki',
          '3404123456780001',
        );

        await prefs.setString('last_active_mode', 'mitra');
        Get.offAllNamed(AppRoutes.mitra);
      } else {
        await prefs.setString('last_active_mode', 'user');
        Get.offAllNamed(AppRoutes.user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        Get.snackbar(
          "Gagal Login",
          "Email ini sudah terdaftar dengan metode login biasa.",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      Get.snackbar("Gagal Login Google", e.message ?? "Terjadi kesalahan autentikasi.", snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar(
        "Gagal Login Google",
        "Login dengan Google gagal. Coba lagi atau gunakan email & password.",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
      return;
    }
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void onShowPassword() {
    showPassword.value = !showPassword.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
