import 'dart:convert';

import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:http/http.dart';

class ArtikelService {
  final Uri url =
      Uri.parse('https://api-berita-indonesia.vercel.app/merdeka/sehat/');

  Future<List<ArtikelModel>> getArtikel() async {
    final response = await get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> listData = data['data']['posts'];
      return listData.map((e) => ArtikelModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load artikel');
    }
  }
}
