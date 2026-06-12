import 'dart:convert';

import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:http/http.dart';

class ArtikelService {
  final Uri url =
      Uri.parse('https://api-berita-indonesia.vercel.app/merdeka/sehat/');

  Future<List<ArtikelModel>> getArtikel() async {
    try {
      final response = await get(url).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> listData = data['data']['posts'];
        return listData.map((e) => ArtikelModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return DummyData.artikels;
  }
}
