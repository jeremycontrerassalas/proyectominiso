import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  // Use unsigned upload preset for client-side uploads
  static const String cloudName = String.fromEnvironment('CLOUDINARY_CLOUD_NAME', defaultValue: 'your_cloud_name');
  static const String uploadPreset = String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET', defaultValue: 'unsigned_preset');

  static void _validateConfig() {
    if (cloudName == 'your_cloud_name' || cloudName.isEmpty) {
      throw Exception('Missing CLOUDINARY_CLOUD_NAME. Pass it with --dart-define=CLOUDINARY_CLOUD_NAME=...');
    }
    if (uploadPreset == 'unsigned_preset' || uploadPreset.isEmpty) {
      throw Exception('Missing CLOUDINARY_UPLOAD_PRESET. Pass it with --dart-define=CLOUDINARY_UPLOAD_PRESET=...');
    }
  }

  static Future<String> uploadImage(File file) async {
    _validateConfig();
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final secureUrl = data['secure_url'] as String?;
      if (secureUrl == null || secureUrl.isEmpty) {
        throw Exception('Cloudinary response did not include secure_url: ${res.body}');
      }
      return secureUrl;
    }
    throw Exception('Cloudinary upload failed (${res.statusCode}): ${res.body}');
  }
}
