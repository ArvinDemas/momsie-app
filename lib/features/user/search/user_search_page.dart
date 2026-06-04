import 'package:douce/features/user/search/user_search_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/obat_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:douce/shared/widget/obat_container.dart';
import 'package:douce/shared/widget/tokobayi_container.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';

class UserSearchPage extends StatelessWidget {
  const UserSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserSearchController controller = Get.put(UserSearchController());
    final TextEditingController searchController = TextEditingController();

    final String query = Get.arguments;

    searchController.text = query;
    controller.onSearch(query);

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
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
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari Kategori, Obat',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open-Sans',
                          fontWeight: FontWeight.w300,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          controller.onSearch(value);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        controller.tokoBayiList.isEmpty &&
                                controller.obatList.isEmpty
                            ? const Text(
                                'Tidak Ada Hasil Yang Ditemukan',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : const SizedBox(),
                        controller.tokoBayiList.isNotEmpty
                            ? resultTokoBayi(controller.tokoBayiList)
                            : const SizedBox(),
                        controller.tokoBayiList.isNotEmpty
                            ? const Divider()
                            : const SizedBox(),
                        controller.obatList.isNotEmpty
                            ? resultObat(controller.obatList)
                            : const SizedBox(),
                        controller.obatList.isNotEmpty
                            ? const Divider()
                            : const SizedBox(),
                      ],
                    ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget resultObat(List<ObatModel> listObat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Obat',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children:
                listObat.map((obat) => ObatContainer(obat: obat)).toList(),
          ),
        ],
      ),
    );
  }

  Widget resultTokoBayi(List<TokoBayiModel> listTokoBayi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Toko Bayi',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: listTokoBayi
                .map(
                  (tokoBayi) => TokoBayiContainer(
                    tokoBayi: tokoBayi,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
