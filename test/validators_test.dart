// Unit tests for the Validators utility class.
// Tests cover all four validators: name, email, password, confirmPassword.

import 'package:flutter_test/flutter_test.dart';
import 'package:shoplite/core/utils/validators.dart';

void main() {
  group('Validators.name', () {
    test('returns null for a valid name', () {
      expect(Validators.name('Jane Smith'), isNull);
    });

    test('returns error when empty', () {
      expect(Validators.name(''), isNotNull);
      expect(Validators.name(null), isNotNull);
    });

    test('returns error when shorter than 2 characters', () {
      expect(Validators.name('A'), isNotNull);
    });

    test('returns error when longer than 40 characters', () {
      expect(Validators.name('A' * 41), isNotNull);
    });

    test('accepts a name exactly 2 characters long', () {
      expect(Validators.name('Jo'), isNull);
    });

    test('accepts a name exactly 40 characters long', () {
      expect(Validators.name('A' * 40), isNull);
    });
  });

  group('Validators.email', () {
    test('returns null for a valid email', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('returns error when empty', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for missing @ symbol', () {
      expect(Validators.email('userexample.com'), isNotNull);
    });

    test('returns error for missing domain', () {
      expect(Validators.email('user@'), isNotNull);
    });

    test('returns error for missing TLD', () {
      expect(Validators.email('user@example'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('returns null for a valid password', () {
      expect(Validators.password('Secret99'), isNull);
    });

    test('returns error when empty', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('returns error for fewer than 8 characters', () {
      expect(Validators.password('Pass1'), isNotNull);
    });

    test('returns error when no letter is present', () {
      expect(Validators.password('12345678'), isNotNull);
    });

    test('returns error when no digit is present', () {
      expect(Validators.password('Password'), isNotNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('returns null when values match', () {
      final validator = Validators.confirmPassword('Secret99');
      expect(validator('Secret99'), isNull);
    });

    test('returns error when values do not match', () {
      final validator = Validators.confirmPassword('Secret99');
      expect(validator('Different1'), isNotNull);
    });

    test('returns error when empty', () {
      final validator = Validators.confirmPassword('Secret99');
      expect(validator(''), isNotNull);
    });
  });
}
