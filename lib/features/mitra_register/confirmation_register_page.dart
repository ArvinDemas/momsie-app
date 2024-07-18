import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/payment_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationRegisterPage extends StatelessWidget {
  const ConfirmationRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int payment = Get.arguments['payment'];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 175,
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
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: PaymentContainer(),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text("Rp $payment",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Please Do Payment On The Account Above. And If you did, please wait for our team to verify your account 1 x 12 hours.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 25,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorDouce.douceBase,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          color: ColorDouce.douceBase,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ConfirmationRegisterController extends GetxController {
  final RxInt payment = 0.obs;

  @override
  void onInit() {
    getDataPayment();
    super.onInit();
  }

  Future<void> getDataPayment() async {
    final UserController userController = Get.find<UserController>();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('register')
        .doc(userController.uid.value)
        .get()
        .then((value) {
      payment.value = value.data()!['payment'];
    });
  }
}
