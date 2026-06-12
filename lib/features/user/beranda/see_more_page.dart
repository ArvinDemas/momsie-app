import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/model/obat_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:douce/shared/widget/artikel_container.dart';
import 'package:douce/shared/widget/obat_container.dart';
import 'package:douce/shared/widget/tokobayi_container.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class SeeMorePage extends StatelessWidget {
  const SeeMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = Get.arguments['title'];
    final List<ArtikelModel>? artikel = Get.arguments['artikel'];
    final List<ObatModel>? obat = Get.arguments['obat'];
    final List<TokoBayiModel>? tokobayi = Get.arguments['tokoBayi'];

    Widget contentWidget;

    switch (title.toLowerCase()) {
      case 'artikel':
        contentWidget = buildArtikelContent(artikel!);
        break;
      case 'obat':
        contentWidget = buildObatContent(obat!);
        break;
      case 'toko bayi':
        contentWidget = buildTokoBayiContent(tokobayi!);
        break;
      default:
        contentWidget = const Text("Unknown title");
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          children: [
            Row(
              children: [
                InkWell(
                  onTap: Get.back,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  "Semua $title",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            contentWidget
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget buildArtikelContent(List<ArtikelModel> listArtikel) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 15,
      children: listArtikel
          .map(
            (artikel) => ArtikelContainer(
              artikel: artikel,
            ),
          )
          .toList(),
    );
  }

  Widget buildObatContent(List<ObatModel> listObat) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 15,
      children: listObat
          .map(
            (obat) => ObatContainer(
              obat: obat,
            ),
          )
          .toList(),
    );
  }

  Widget buildTokoBayiContent(List<TokoBayiModel> listTokoBayi) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 15,
      children: listTokoBayi
          .map(
            (tokoBayi) => TokoBayiContainer(
              tokoBayi: tokoBayi,
            ),
          )
          .toList(),
    );
  }
}
