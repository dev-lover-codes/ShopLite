// Reads compile-time environment variables injected via --dart-define.
// If values are missing, the app shows a configuration error screen.

class Env {
  // The Supabase project URL (injected at build time, never hardcoded).
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  // The Supabase anon key (injected at build time, never hardcoded).
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Returns true when both values have been injected at build time.
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
