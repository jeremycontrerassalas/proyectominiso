import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
    final baseUri = Uri.parse(normalizedBase);
    return baseUri.resolve(path);
  }

  static void _log(String message) {
    if (kDebugMode) {
      debugPrint('[ApiService] $message');
    }
  }

  static String _formatNetworkError(Object error, [StackTrace? stackTrace]) {
    final buffer = StringBuffer()
      ..write('No se pudo conectar con $baseUrl. ')
      ..write('Verifica que el dispositivo tenga internet, que el DNS resuelva Railway y que el backend esté activo. ')
      ..write('Error original: $error');
    if (stackTrace != null && kDebugMode) {
      buffer.write('\n$stackTrace');
    }
    return buffer.toString();
  }

  static Future<List<Product>> fetchProducts() async {
    try {
      final uri = _buildUri('/products');
      _log('GET $uri');
      final res = await http.get(uri).timeout(const Duration(seconds: 20));
      _log('GET $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body) as List;
        return data.map((e) => Product.fromJson(e)).toList();
      }
      throw Exception('Failed to load products: ${res.statusCode} ${res.body}');
    } on SocketException catch (error, stackTrace) {
      throw Exception(_formatNetworkError(error, stackTrace));
    } on TimeoutException catch (error, stackTrace) {
      throw Exception('Timeout waiting for $baseUrl. ${_formatNetworkError(error, stackTrace)}');
    } on HttpException catch (error, stackTrace) {
      throw Exception(_formatNetworkError(error, stackTrace));
    } on HandshakeException catch (error, stackTrace) {
      throw Exception('TLS/SSL error connecting to $baseUrl. ${_formatNetworkError(error, stackTrace)}');
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
      final uri = _buildUri('/products');
      _log('POST $uri');
      final res = await http.post(
        uri,
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
    } on SocketException catch (error, stackTrace) {
      throw Exception(_formatNetworkError(error, stackTrace));
    } on TimeoutException catch (error, stackTrace) {
      throw Exception('Timeout waiting for $baseUrl. ${_formatNetworkError(error, stackTrace)}');
    } on HttpException catch (error, stackTrace) {
      throw Exception(_formatNetworkError(error, stackTrace));
    } on HandshakeException catch (error, stackTrace) {
      throw Exception('TLS/SSL error connecting to $baseUrl. ${_formatNetworkError(error, stackTrace)}');
    }
  }

  static Future<bool> ping() async {
    try {
      final uri = _buildUri('/health');
      _log('GET $uri');
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      _log('GET $uri -> ${res.statusCode}');
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (error) {
      _log('Health check failed: $error');
      return false;
    }
  }
}
