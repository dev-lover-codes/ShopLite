// Riverpod providers for products and categories.
// productApiServiceProvider: shared ProductApiService instance.
// productsProvider: fetches the full product list.
// categoriesProvider: fetches the category list.
// productDetailProvider: fetches a single product by ID.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/data/models/product.dart';
import 'package:shoplite/data/services/product_api_service.dart';

/// Single shared [ProductApiService] instance for the whole app.
final productApiServiceProvider = Provider<ProductApiService>((ref) {
  final service = ProductApiService();
  // Dispose the HTTP client when this provider is no longer used.
  ref.onDispose(service.dispose);
  return service;
});

/// Fetches the full list of products from the FakeStore API.
/// Returns an [AsyncValue] so the UI can handle loading/error/data states.
final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productApiServiceProvider).fetchProducts();
});

/// Fetches the list of product category strings.
final categoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(productApiServiceProvider).fetchCategories();
});

/// Fetches a single product by [id]. Each unique [id] is cached separately.
final productDetailProvider = FutureProvider.family<Product, int>((ref, id) {
  return ref.watch(productApiServiceProvider).fetchProduct(id);
});
