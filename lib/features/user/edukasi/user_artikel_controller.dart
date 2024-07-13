import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class UserArtikelController extends GetxController {
  final RxString content = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final String link;

  UserArtikelController(this.link);

  @override
  void onInit() {
    super.onInit();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    try {
      _isLoading.value = true;
      final response = await http.get(Uri.parse(link));
      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ==
            true) {
          final data = json.decode(response.body);
          content.value = data['data']['content'];
          _isLoading.value = false;
        } else {
          final document = html_parser.parse(response.body);
          final paragraphs = document.getElementsByTagName('p');
          content.value =
              paragraphs.map((dom.Element p) => p.text).join('\n\n');
          _isLoading.value = false;
        }
      } else {
        throw Exception(
            'Failed to load content with status code: ${response.statusCode}');
      }
    } catch (e) {
      _isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}
