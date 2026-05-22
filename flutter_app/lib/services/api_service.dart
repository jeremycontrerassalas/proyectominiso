import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Set this to your Railway backend URL for release APKs.
  // You can still override it with --dart-define=API_BASE=... when needed.
  static const String productionBaseUrl = 'https://proyectominiso-production.up.railway.app';
  static const String baseUrl = String.fromEnvironment('API_BASE', defaultValue: productionBaseUrl);

  static Uri _buildUri(String path) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    if (!normalizedBase.startsWith('http://') && !normalizedBase.startsWith('https://')) {
      throw Exception('Invalid API_BASE URL: $normalizedBase');
    }
    return Uri.parse('$normalizedBase$path');
  }

  static Future<List<Product>> fetchProducts() async {
    try {
      final res = await http.get(_buildUri('/products')).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body) as List;
        return data.map((e) => Product.fromJson(e)).toList();
      }
      throw Exception('Failed to load products: ${res.statusCode} ${res.body}');
    } on SocketException catch (e) {
      throw Exception('Network/DNS error reaching $baseUrl: $e');
    }
  }

  static Future<Product> createProduct({
    required String title,
    required String code,
    required String tags,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final res = await http.post(
        _buildUri('/products'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({
          'title': title,
          'code': code,
          'tags': tags,
          'description': description,
          'imageUrl': imageUrl,
        }),
      ).timeout(const Duration(seconds: 20));

      if (res.statusCode == 201 || res.statusCode == 200) {
        return Product.fromJson(jsonDecode(res.body));
      }
      throw Exception('Failed to create product: ${res.statusCode} ${res.body}');
    } on SocketException catch (e) {
      throw Exception('Network/DNS error reaching $baseUrl: $e');
    }
  }
}
