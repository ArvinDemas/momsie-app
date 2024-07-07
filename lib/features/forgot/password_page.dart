import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/alert_dialog.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:flutter/material.dart';

class CreatePasswordPage extends StatelessWidget {
  const CreatePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
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
                    'Buat Password Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                      "Buat kata sandi baru anda untuk login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    hintText: "Password Baru",
                    iconImage: const Icon(Icons.lock_outline),
                    isPassword: true,
                    controller: TextEditingController(),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Konfirmasi Password",
                    iconImage: const Icon(Icons.lock_outline),
                    isPassword: true,
                    controller: TextEditingController(),
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      showCustomDialog(context);
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
                        "Lanjut",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomAlertDialog(
          isSuccess: true,
          descText: "Password Berhasil diubah",
          destination: '/login',
        );
      },
    );
  }
}
