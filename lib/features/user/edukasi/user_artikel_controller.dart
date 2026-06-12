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
  final String fallbackContent;

  UserArtikelController(this.link, this.fallbackContent);

  @override
  void onInit() {
    super.onInit();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    try {
      _isLoading.value = true;
      final response = await http.get(Uri.parse(link)).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ==
            true) {
          final data = json.decode(response.body);
          content.value = data['data']['content'] ?? '';
          _isLoading.value = false;
        } else {
          final document = html_parser.parse(response.body);
          final paragraphs = document.getElementsByTagName('p');
          final text = paragraphs
              .map((dom.Element p) => p.text.trim())
              .where((t) => t.isNotEmpty)
              .join('\n\n');
          if (text.length > 50) {
            content.value = text;
          } else {
            content.value = fallbackContent.isNotEmpty
                ? fallbackContent
                : 'Silakan baca artikel lengkap di: $link';
          }
          _isLoading.value = false;
        }
      } else {
        content.value = fallbackContent.isNotEmpty
            ? fallbackContent
            : 'Silakan baca artikel lengkap di: $link';
        _isLoading.value = false;
      }
    } catch (e) {
      content.value = fallbackContent.isNotEmpty
          ? fallbackContent
          : 'Silakan baca artikel lengkap di: $link';
      _isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}
