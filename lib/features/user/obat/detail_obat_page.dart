import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/obat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailObatPage extends StatelessWidget {
  const DetailObatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ObatModel obat = Get.arguments;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  const Text(
                    "Detail Obat",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.heart_broken_rounded,
                    color: ColorDouce.douceBase,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorDouce.douceBase,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.network(
                          obat.image,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            obat.nama,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "No Reg. ${obat.noreg}",
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Rp ${obat.harga}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.black,
                height: 10,
                thickness: 0.7,
              ),
              const SizedBox(height: 20),
              const Text(
                "Deskripsi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                obat.deskripsi,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Aturan Pakai",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                obat.aturan,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
