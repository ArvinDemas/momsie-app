import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoulaContainer extends StatelessWidget {
  const DoulaContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed("/detail-doula"),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, -30),
                    child: Image.asset(
                      "assets/images/topdoula.png",
                      width: 75,
                      height: 75,
                    ),
                  ),
                ),
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, 100),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: ColorDouce.douceBase,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dr. Zahra",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.orange,
                      ),
                      Text(
                        "4.9",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Text(
                "Ahli Gizi",
                style: TextStyle(
                  color: ColorDouce.douceBase,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
