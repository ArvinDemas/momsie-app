import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtikelContainer extends StatelessWidget {
  const ArtikelContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/user-artikel'),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 150,
        decoration: BoxDecoration(
          color: ColorDouce.douceBase,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/artikel.png',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "By Lionel Messi",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const Text(
              "Tips dan Trik untuk Ibu Hamil",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "10 Agustus 2021",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
