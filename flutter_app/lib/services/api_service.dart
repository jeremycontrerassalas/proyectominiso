import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Set this to your Railway backend URL for release APKs.
  // You can still override it with --dart-define=API_BASE=... when needed.
  static const String productionBaseUrl = 'https://YOUR-BACKEND.up.railway.app';
  static const String baseUrl = String.fromEnvironment('API_BASE', defaultValue: productionBaseUrl);

  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/products'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to load products');
  }

  static Future<Product> createProduct({
    required String title,
    required String code,
    required String tags,
    String? description,
    String? imageUrl,
  }) async {
    final res = await http.post(Uri.parse('$baseUrl/products'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({
          'title': title,
          'code': code,
          'tags': tags,
          'description': description,
          'imageUrl': imageUrl,
        }));

    if (res.statusCode == 201 || res.statusCode == 200) {
      return Product.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to create product: ${res.body}');
  }
}
