import 'package:douce/features/register/register_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController registerController = Get.put(RegisterController());

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              color: ColorDouce.douceBase,
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
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Username",
                  iconImage: const Icon(Icons.person_2_outlined),
                  isPassword: false,
                  controller: usernameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Email",
                  iconImage: const Icon(Icons.email_outlined),
                  isPassword: true,
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Password",
                  iconImage: const Icon(Icons.lock_outline),
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => registerController.onCheckBox(),
                      child: Obx(
                        () => Icon(
                          !registerController.isSetuju.value
                              ? Icons.check_box_outline_blank_outlined
                              : Icons.check_box_outlined,
                          size: 26,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Saya menyetujui ",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              "Ketentuan dan Layanan",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w400,
                                color: ColorDouce.lightPink,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "dan",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              " Kebijakan Privasi",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w400,
                                color: ColorDouce.lightPink,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Container(
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
                  child: InkWell(
                    onTap: () {
                      registerController.successRegister();
                    },
                    child: const Text(
                      "Daftar",
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
                Container(
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
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sudah Mempunyai Akun?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        registerController.goToLogin();
                      },
                      child: Text(
                        " Masuk",
                        style: TextStyle(
                          color: ColorDouce.lightPink,
                          fontSize: 12,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
