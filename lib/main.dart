// App entry point. Initialises Supabase, then hands control to ShopLiteApp
// wrapped in a ProviderScope so every Riverpod provider is available.
// If the environment variables are missing the user sees a friendly error.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/app/app.dart';
import 'package:shoplite/core/config/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter's widget binding is ready before calling platform code.
  WidgetsFlutterBinding.ensureInitialized();

  // If environment variables are missing, skip Supabase init and show the
  // "not configured" screen via the ShopLiteApp guard in env.dart.
  if (Env.isConfigured) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      // publishableKey is the current name for the anon key in supabase_flutter 2.x+
      publishableKey: Env.supabaseAnonKey,
    );
  }

  runApp(
    // ProviderScope is the root of the Riverpod tree; must wrap the whole app.
    const ProviderScope(child: ShopLiteApp()),
  );
}
