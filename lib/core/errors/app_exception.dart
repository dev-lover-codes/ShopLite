// Defines a single exception type used throughout the app.
// Every service layer converts raw errors into an AppException with a
// human-readable message so the UI never shows raw stack traces.

class AppException implements Exception {
  /// The user-readable error message.
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}
