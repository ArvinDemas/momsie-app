import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  RxBool showPassword = false.obs;

  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;

  Future<void> tryLogin(String email, String password) async {
    if (email == '' || password == '') {
      Get.snackbar(
        'Empty fields',
        'Please fill in all fields',
        snackPosition: SnackPosition.TOP,
      );
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
      userDoc.data() as Map<String, dynamic>;

      final UserController userController = Get.find<UserController>();
      userController.setUser(
        userDoc['username'],
        email,
        userCredential.user!.uid,
        userDoc['image'],
        userDoc['isDoula'],
      );

      if (userDoc['isDoula'] == true) {
        final DocumentSnapshot mitraData = await firestore
            .collection('mitra')
            .doc(userCredential.user!.uid)
            .get();
        if (mitraData.exists) {
          userController.setDoula(
            mitraData['name'],
            mitraData['alamat'],
            mitraData['kotaProvinsi'],
            mitraData['biografi'],
            mitraData['image'],
            mitraData['jenisKelamin'],
            mitraData['nik'],
          );
        }
        Get.offAllNamed('/mitra');
      } else {
        Get.offAllNamed('/user');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Wrong email or password',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
  }

  Future<void> tryGoogleLogin() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: '5481212381-5tltq0if3b3s54o0pu0m056jeiovugbj.apps.googleusercontent.com',
      );

      // Disconnect session lama jika ada agar prompt akun Google selalu muncul
      await googleSignIn.signOut();
      
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User membatalkan dialog login Google
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
      final DocumentSnapshot userDoc = await firestore
          .collection('user')
          .doc(userCredential.user!.uid)
          .get();

      String username;
      String? image;
      bool isDoula;

      if (!userDoc.exists) {
        username = userCredential.user!.displayName ?? 'User';
        image = userCredential.user!.photoURL;
        isDoula = false;
        await firestore.collection('user').doc(userCredential.user!.uid).set({
          'username': username,
          'email': userCredential.user!.email,
          'image': image,
          'uid': userCredential.user!.uid,
          'isDoula': isDoula,
        });
      } else {
        username = userDoc['username'];
        image = userDoc['image'];
        isDoula = userDoc['isDoula'] ?? false;
      }

      final UserController userController = Get.find<UserController>();
      userController.setUser(
        username,
        userCredential.user!.email!,
        userCredential.user!.uid,
        image ?? '',
        isDoula,
      );

      if (isDoula) {
        final DocumentSnapshot mitraData = await firestore
            .collection('mitra')
            .doc(userCredential.user!.uid)
            .get();
        if (mitraData.exists) {
          userController.setDoula(
            mitraData['name'],
            mitraData['alamat'],
            mitraData['kotaProvinsi'],
            mitraData['biografi'],
            mitraData['image'],
            mitraData['jenisKelamin'],
            mitraData['nik'],
          );
        }
        Get.offAllNamed('/mitra');
      } else {
        Get.offAllNamed('/user');
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
        "Pastikan SHA-1 Fingerprint telah terdaftar di Firebase Console & Provider Google diaktifkan.",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return;
    }
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  void forgotPassword() {
    Get.toNamed('/forgot-password');
  }

  void onShowPassword() {
    showPassword.value = !showPassword.value;
  }
}
