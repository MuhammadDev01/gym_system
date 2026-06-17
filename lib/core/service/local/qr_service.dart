import 'dart:convert';

class QrService {
  Future<String> createQR({
    required String image,
    required name,
    required String phone,
  }) async {
    final String qrData = jsonEncode({
      'name': name,
      'phone': phone,
      'image': image,
    });
    return qrData;
  }
}
