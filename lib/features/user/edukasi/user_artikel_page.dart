import 'package:douce/features/user/edukasi/user_artikel_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserArtikelPage extends StatelessWidget {
  const UserArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ArtikelModel artikel = Get.arguments as ArtikelModel;

    if (Get.isRegistered<UserArtikelController>()) {
      Get.delete<UserArtikelController>();
    }
    final UserArtikelController controller =
        Get.put(UserArtikelController(artikel.link, artikel.description));
    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
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
                    "Artikel",
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
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  artikel.thumbnail,
                  width: double.infinity,
                  height: 175,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                artikel.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    artikel.pubDate,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () => controller.content.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        controller.content.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }
}
