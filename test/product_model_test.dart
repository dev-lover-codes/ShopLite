// Unit tests for Product.fromJson.
// Covers both valid JSON and several invalid/incomplete inputs.

import 'package:flutter_test/flutter_test.dart';
import 'package:shoplite/core/errors/app_exception.dart';
import 'package:shoplite/data/models/product.dart';

void main() {
  // A minimal valid product JSON as returned by the FakeStore API.
  final validJson = <String, dynamic>{
    'id': 1,
    'title': 'Test Product',
    'price': 29.99,
    'description': 'A great product.',
    'category': "men's clothing",
    'image': 'https://example.com/image.png',
    'rating': {'rate': 4.5, 'count': 120},
  };

  group('Product.fromJson – valid input', () {
    test('parses all fields correctly', () {
      final product = Product.fromJson(validJson);
      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 29.99);
      expect(product.description, 'A great product.');
      expect(product.category, "men's clothing");
      expect(product.image, 'https://example.com/image.png');
      expect(product.ratingRate, 4.5);
      expect(product.ratingCount, 120);
    });

    test('defaults ratingRate to 0.0 when rating map is absent', () {
      final json = Map<String, dynamic>.from(validJson)..remove('rating');
      final product = Product.fromJson(json);
      expect(product.ratingRate, 0.0);
      expect(product.ratingCount, 0);
    });

    test('defaults description to empty string when absent', () {
      final json = Map<String, dynamic>.from(validJson)..remove('description');
      final product = Product.fromJson(json);
      expect(product.description, '');
    });
  });

  group('Product.fromJson – invalid input', () {
    test('throws AppException when "id" is missing', () {
      final json = Map<String, dynamic>.from(validJson)..remove('id');
      expect(() => Product.fromJson(json), throwsA(isA<AppException>()));
    });

    test('throws AppException when "title" is missing', () {
      final json = Map<String, dynamic>.from(validJson)..remove('title');
      expect(() => Product.fromJson(json), throwsA(isA<AppException>()));
    });

    test('throws AppException when "price" is missing', () {
      final json = Map<String, dynamic>.from(validJson)..remove('price');
      expect(() => Product.fromJson(json), throwsA(isA<AppException>()));
    });
  });

  group('Product equality', () {
    test('two products with the same id are equal', () {
      final a = Product.fromJson(validJson);
      final b = Product.fromJson({...validJson, 'title': 'Different Title'});
      expect(a, equals(b));
    });

    test('two products with different ids are not equal', () {
      final a = Product.fromJson(validJson);
      final b = Product.fromJson({...validJson, 'id': 2});
      expect(a, isNot(equals(b)));
    });
  });
}
