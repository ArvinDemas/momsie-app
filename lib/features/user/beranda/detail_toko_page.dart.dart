import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailTokoPage extends StatelessWidget {
  const DetailTokoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 30,
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
                    "Detail Toko",
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
                      child: Image.asset("assets/images/toko.png"),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Baby Shop Jogja",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Jl. Kaliurang KM 5,5 Yogyakarta",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Row(children: [
                            Icon(Icons.star, color: Colors.orange),
                            Text(
                              "4.9",
                              style: TextStyle(fontSize: 14),
                            )
                          ])
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
              const Text(
                "Baby Shop Jogja adalah toko perlengkapan bayi yang menyediakan berbagai macam kebutuhan bayi dan anak-anak. Kami menyediakan berbagai macam produk berkualitas dengan harga terjangkau.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Product",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              productContainer(),
              const SizedBox(height: 10),
              productContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget productContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/pakaian.png",
            width: 60,
            height: 60,
          ),
          const SizedBox(width: 20),
          const Text(
            "Pakaian Bayi",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
