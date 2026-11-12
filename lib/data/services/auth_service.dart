// Supabase Auth service. Wraps sign-up, sign-in and sign-out calls.
// Translates raw GoTrueException messages into user-readable strings so
// widgets never show technical error codes.

import 'package:shoplite/core/errors/app_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _db;

  AuthService(this._db);

  /// The currently authenticated user, or null if logged out.
  User? get currentUser => _db.auth.currentUser;

  /// A stream that emits every time the auth state changes (login/logout).
  Stream<AuthState> get authStateChanges => _db.auth.onAuthStateChange;

  /// Registers a new user. The [name] is stored in the user's metadata.
  /// Returns true if a session was created immediately (email confirmation
  /// disabled), or false if the user needs to confirm their email first.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _db.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'name': name.trim()}, // stored in auth.users.raw_user_meta_data
      );
      // A non-null session means the user is logged in immediately.
      return response.session != null;
    } on AuthException catch (e) {
      throw AppException(_mapAuthError(e.message));
    } catch (e) {
      throw AppException('Sign-up failed. Please try again.');
    }
  }

  /// Signs the user in with email and password.
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _db.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } on AuthException catch (e) {
      throw AppException(_mapAuthError(e.message));
    } catch (e) {
      throw AppException('Login failed. Please try again.');
    }
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    try {
      await _db.auth.signOut();
    } on AuthException catch (e) {
      throw AppException(_mapAuthError(e.message));
    } catch (e) {
      throw AppException('Could not sign out. Please try again.');
    }
  }

  /// Returns the display name stored in the user's metadata, with a fallback.
  String displayName(User user) {
    final meta = user.userMetadata;
    return (meta?['name'] as String?)?.trim().isNotEmpty == true
        ? meta!['name'] as String
        : user.email ?? 'User';
  }

  /// Maps common GoTrue error message fragments to friendly text.
  String _mapAuthError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid credentials')) {
      return 'Email or password is incorrect.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Please confirm your email address before logging in.';
    }
    if (lower.contains('user already registered')) {
      return 'An account with this email already exists.';
    }
    if (lower.contains('password should be at least')) {
      return 'Password must be at least 6 characters.';
    }
    if (lower.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    return raw.isNotEmpty ? raw : 'An authentication error occurred.';
  }
}
