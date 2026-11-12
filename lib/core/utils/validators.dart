// Form-field validators used across all auth screens.
// Every function returns null when valid, or an error string when invalid.

class Validators {
  Validators._(); // Prevent instantiation – static helpers only.

  /// Name must be between 2 and 40 characters.
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required.';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters.';
    }
    if (trimmed.length > 40) {
      return 'Name must be 40 characters or fewer.';
    }
    return null;
  }

  /// Email must match a standard pattern.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  /// Password: at least 8 chars, one letter, one digit.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'Password must contain at least one letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number.';
    }
    return null;
  }

  /// Confirm password must match the original password field value.
  static String? Function(String?) confirmPassword(String? original) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password.';
      }
      if (value != original) {
        return 'Passwords do not match.';
      }
      return null;
    };
  }
}
