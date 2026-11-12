// HTTP service for the FakeStore public API.
// All network calls go through this class. Errors are converted into
// AppException with readable messages so the UI can display them directly.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shoplite/core/errors/app_exception.dart';
import 'package:shoplite/data/models/product.dart';

class ProductApiService {
  static const _base = 'https://fakestoreapi.com';

  // Shared HTTP client so connections can be reused across requests.
  final http.Client _client;

  // Every request times out after 10 seconds to avoid hanging indefinitely.
  static const _timeout = Duration(seconds: 10);

  ProductApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the full product list from the API.
  Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse('$_base/products');
    try {
      final response = await _client.get(uri).timeout(_timeout);
      _checkStatus(response);
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on SocketException {
      throw const AppException(
        'No internet connection. Check your network and try again.',
      );
    } on TimeoutException {
      throw const AppException(
        'The server took too long to respond. Try again later.',
      );
    } catch (e) {
      throw AppException('Unexpected error fetching products: $e');
    }
  }

  /// Fetches a single product by its [id].
  Future<Product> fetchProduct(int id) async {
    final uri = Uri.parse('$_base/products/$id');
    try {
      final response = await _client.get(uri).timeout(_timeout);
      _checkStatus(response);
      return Product.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } on SocketException {
      throw const AppException(
        'No internet connection. Check your network and try again.',
      );
    } on TimeoutException {
      throw const AppException(
        'The server took too long to respond. Try again later.',
      );
    } catch (e) {
      throw AppException('Unexpected error fetching product $id: $e');
    }
  }

  /// Fetches the list of product category strings.
  Future<List<String>> fetchCategories() async {
    final uri = Uri.parse('$_base/products/categories');
    try {
      final response = await _client.get(uri).timeout(_timeout);
      _checkStatus(response);
      final list = jsonDecode(response.body) as List<dynamic>;
      return list.cast<String>();
    } on AppException {
      rethrow;
    } on SocketException {
      throw const AppException(
        'No internet connection. Check your network and try again.',
      );
    } on TimeoutException {
      throw const AppException(
        'The server took too long to respond. Try again later.',
      );
    } catch (e) {
      throw AppException('Unexpected error fetching categories: $e');
    }
  }

  /// Throws [AppException] if the HTTP status code indicates failure.
  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AppException(
        'Server returned an error (HTTP ${response.statusCode}). Try again later.',
      );
    }
  }

  void dispose() => _client.close();
}
