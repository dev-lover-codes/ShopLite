// Product model that maps to the FakeStore API JSON response.
// fromJson throws an AppException with a clear message if required fields
// are missing, so the error surfaces in the UI rather than crashing.

import 'package:shoplite/core/errors/app_exception.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
  });

  /// Parses a single product from a JSON map.
  /// Throws [AppException] when a required field is absent or of the wrong type.
  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      final rating = json['rating'] as Map<String, dynamic>? ?? {};
      return Product(
        id:
            (json['id'] as num?)?.toInt() ??
            (throw AppException('Product JSON is missing "id".')),
        title:
            json['title'] as String? ??
            (throw AppException('Product JSON is missing "title".')),
        price:
            (json['price'] as num?)?.toDouble() ??
            (throw AppException('Product JSON is missing "price".')),
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? '',
        image: json['image'] as String? ?? '',
        ratingRate: (rating['rate'] as num?)?.toDouble() ?? 0.0,
        ratingCount: (rating['count'] as num?)?.toInt() ?? 0,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to parse product data: $e');
    }
  }

  /// Converts the product back to a JSON map (useful for caching).
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
    'rating': {'rate': ratingRate, 'count': ratingCount},
  };

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
