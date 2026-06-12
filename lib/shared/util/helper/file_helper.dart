import 'file_helper_stub.dart'
    if (dart.library.html) 'file_helper_web.dart'
    if (dart.library.io) 'file_helper_mobile.dart';

class FileHelper {
  static Future<void> saveAndOpenFile({
    required List<int> bytes,
    required String filename,
    required String mimeType,
  }) async {
    await saveAndOpen(
      bytes: bytes,
      filename: filename,
      mimeType: mimeType,
    );
  }
}
