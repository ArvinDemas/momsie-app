import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoulaContainer extends StatelessWidget {
  const DoulaContainer({
    super.key,
    required this.doula,
  });

  final DoulaModel doula;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed("/detail-doula", arguments: {
        "doula": doula,
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, -30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        doula.image,
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
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
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      doula.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.orange,
                      ),
                      Text(
                        doula.rating,
                        style: const TextStyle(
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
              offset: const Offset(0, -15),
              child: Text(
                doula.job,
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
