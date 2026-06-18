import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalImageService {
  static String? _directoryPath;

  static Future<String> get _directory async {
    final dir = await getApplicationDocumentsDirectory();
    _directoryPath = dir.path;
    return dir.path;
  }

  static Future<void> saveImage(String base64String, String fileName) async {
    final dir = await _directory;
    final file = File('$dir/$fileName');
    final bytes = base64Decode(base64String);
    await file.writeAsBytes(bytes);
  }

  static Future<String?> getImagePath(String fileName) async {
    final dir = await _directory;
    final file = File('$dir/$fileName');
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  static String? getImagePathSync(String fileName) {
    if (_directoryPath == null) return null;
    final file = File('$_directoryPath/$fileName');
    if (file.existsSync()) {
      return file.path;
    }
    return null;
  }
}
