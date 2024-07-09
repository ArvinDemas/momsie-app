import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/obat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ObatContainer extends StatelessWidget {
  const ObatContainer({super.key, required this.obat});

  final ObatModel obat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed("/detail-obat", arguments: obat),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
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
                child: Image.network(
                  obat.image,
                  width: 75,
                  height: 75,
                ),
              ),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  obat.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  obat.jenis,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Rp ${obat.harga} ",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
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
