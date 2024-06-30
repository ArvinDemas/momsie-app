import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/topbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserObatPage extends StatelessWidget {
  const UserObatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const TopBar(),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Image.asset('assets/images/obat.png'),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Obat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorDouce.douceBase,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              obatContainer(),
              const SizedBox(height: 10),
              obatContainer(),
              const SizedBox(height: 10),
              obatContainer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget obatContainer() {
    return InkWell(
      onTap: () => Get.toNamed("/detail-obat"),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: ColorDouce.douceBase,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/obat2.png',
                  width: 75,
                  height: 75,
                ),
              ),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Paracetamol",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Vitamin",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Rp 10.000",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
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
