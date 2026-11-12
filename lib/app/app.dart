// Root application widget. Builds the MaterialApp.router with light/dark
// themes and the go_router instance. The router is built inside a
// ConsumerStatefulWidget so it can read Riverpod providers for the auth
// redirect guard and is only created once per app lifecycle.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shoplite/app/router.dart';
import 'package:shoplite/app/theme.dart';

class ShopLiteApp extends ConsumerStatefulWidget {
  const ShopLiteApp({super.key});

  @override
  ConsumerState<ShopLiteApp> createState() => _ShopLiteAppState();
}

class _ShopLiteAppState extends ConsumerState<ShopLiteApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Build the router once and reuse it. The refreshListenable inside
    // buildRouter will cause the redirect to re-evaluate on auth changes.
    _router = buildRouter(ref);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ShopLite',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      // Follow the system preference; users can override in OS settings.
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
