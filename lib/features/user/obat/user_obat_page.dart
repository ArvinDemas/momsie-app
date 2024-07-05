import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/obat_container.dart';
import 'package:flutter/material.dart';

class UserObatPage extends StatelessWidget {
  const UserObatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isApotek: true,
      childWidget: ListView(
        padding: const EdgeInsets.all(0),
        children: [
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
                const ObatContainer(),
                const SizedBox(height: 10),
                const ObatContainer(),
                const SizedBox(height: 10),
                const ObatContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
