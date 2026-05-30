import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RumahSakitContainer extends StatelessWidget {
  const RumahSakitContainer(
      {super.key, this.fullWidth = true, this.onTap, required this.rumahSakit});

  final bool fullWidth;
  final Function? onTap;
  final RumahSakitModel rumahSakit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Get.toNamed("/detail-rumah-sakit", arguments: rumahSakit);
        }
      },
      child: Container(
        width: fullWidth ? double.infinity : 300,
        padding: const EdgeInsets.all(12),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                rumahSakit.image,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rumahSakit.nama,
                  style: TextStyle(
                    fontSize: fullWidth ? 18 : 16,
                    fontWeight: FontWeight.w500,
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
                      rumahSakit.rating,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              rumahSakit.alamat,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              overflow: !fullWidth ? TextOverflow.ellipsis : null,
            ),
          ],
        ),
      ),
    );
  }
}
