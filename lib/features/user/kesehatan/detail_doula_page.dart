import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';

class DetailDoulaPage extends StatelessWidget {
  const DetailDoulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DoulaModel doula = Get.arguments["doula"];

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          SafeArea(
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
                    "Detail Doula",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.heart_broken_rounded,
                    color: Colors.transparent,
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
                      child: Image.network(
                        doula.image,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            doula.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(doula.job),
                          Text(
                            doula.alamat,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Text(
                                doula.rating,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(height: 15),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 25,
                children: [
                  informationCircle(doula.jenisKelamin, Icons.female),
                  informationCircle(doula.rating, Icons.star),
                  informationCircle(doula.job, Icons.work),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "Biografi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(doula.biografi),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }

  Widget informationCircle(String title, IconData icon) {
    return SizedBox(
      width: 75,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999),
              color: ColorDouce.kindaRed,
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(
              icon,
              color: ColorDouce.douceBase,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorDouce.douceBase,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
