// Riverpod providers for authentication state.
// authServiceProvider: single instance of AuthService.
// authStateProvider: streams Supabase auth changes into an AsyncValue.
// currentUserProvider: exposes the current User or null.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/data/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides the [AuthService] instance backed by the Supabase singleton.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(Supabase.instance.client);
});

/// Streams authentication state changes (sign in / sign out events).
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Exposes the currently authenticated [User], or null when logged out.
final currentUserProvider = Provider<User?>((ref) {
  // We start with the synchronously available user from the Supabase session.
  final asyncState = ref.watch(authStateProvider);
  return asyncState.whenOrNull(data: (s) => s.session?.user) ??
      Supabase.instance.client.auth.currentUser;
});
