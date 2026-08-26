import 'package:douce/features/login/login_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const AnimatedGradientBackground(),
            ListView(
              padding: const EdgeInsets.all(0),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 75,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            ' Mom',
                            style: TextStyle(
                              fontSize: 20,
                              color: ColorDouce.lightPink,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            ', Save the',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            ' Kid',
                            style: TextStyle(
                              color: ColorDouce.lightPink,
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Text(
                        loginController.isDoulaLogin.value
                            ? 'Selamat datang, Mitra Doula.'
                            : 'Selamat datang, Ibu Hamil.',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                      const Text(
                        'Langkah pertama menuju keajaiban',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: "Email",
                        iconImage: const Icon(Icons.person_2_outlined),
                        isPassword: false,
                        controller: loginController.emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: "Password",
                        iconImage: const Icon(Icons.lock_outline),
                        isPassword: true,
                        controller: loginController.passwordController,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => loginController.forgotPassword(),
                            child: Text(
                              "Lupa Password ?",
                              style: TextStyle(
                                color: ColorDouce.lightPink,
                                fontSize: 12,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Segmented Role Selector: [ Ibu Hamil ]  [ Mitra Doula ]
                      Obx(() {
                        final isDoula = loginController.isDoulaLogin.value;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                          ),
                          child: Row(
                            children: [
                              // Tab 1: Ibu Hamil
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => loginController.isDoulaLogin.value = false,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: !isDoula ? ColorDouce.douceBase : Colors.transparent,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: !isDoula
                                          ? [
                                              BoxShadow(
                                                color: ColorDouce.douceBase.withValues(alpha: 0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          size: 16,
                                          color: !isDoula ? Colors.white : Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Ibu Hamil",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: !isDoula ? FontWeight.bold : FontWeight.w500,
                                            color: !isDoula ? Colors.white : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Tab 2: Mitra Doula
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => loginController.isDoulaLogin.value = true,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isDoula ? ColorDouce.douceBase : Colors.transparent,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: isDoula
                                          ? [
                                              BoxShadow(
                                                color: ColorDouce.douceBase.withValues(alpha: 0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.medical_services_outlined,
                                          size: 16,
                                          color: isDoula ? Colors.white : Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Mitra Doula",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isDoula ? FontWeight.bold : FontWeight.w500,
                                            color: isDoula ? Colors.white : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          loginController.tryLogin(
                            loginController.emailController.value.text,
                            loginController.passwordController.value.text,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: ColorDouce.douceBase,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: ColorDouce.lightPink.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 0.5,
                            decoration: BoxDecoration(
                              color: ColorDouce.lightPink,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Atau",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 100,
                            height: 0.5,
                            decoration: BoxDecoration(
                              color: ColorDouce.lightPink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          loginController.tryGoogleLogin();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 15),
                              const Text(
                                "Masuk dengan Google",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Belum mempunyai akun?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              loginController.goToRegister();
                            },
                            child: Text(
                              " Daftar",
                              style: TextStyle(
                                color: ColorDouce.lightPink,
                                fontSize: 12,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

