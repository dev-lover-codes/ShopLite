// App-wide router powered by go_router.
// A redirect guard sends unauthenticated users to /login and prevents
// logged-in users from accessing /login or /signup again.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shoplite/providers/auth_provider.dart';
import 'package:shoplite/screens/auth/login_screen.dart';
import 'package:shoplite/screens/auth/signup_screen.dart';
import 'package:shoplite/screens/favourites/favourites_screen.dart';
import 'package:shoplite/screens/home/home_screen.dart';
import 'package:shoplite/screens/products/product_detail_screen.dart';
import 'package:shoplite/screens/products/products_screen.dart';
import 'package:shoplite/screens/splash/splash_screen.dart';

/// Creates the app router. Accepts a [WidgetRef] so the redirect guard can
/// read the current auth state from Riverpod providers.
GoRouter buildRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/splash',
    // The redirect is re-evaluated whenever the auth state changes.
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authServiceProvider).authStateChanges,
    ),
    redirect: (BuildContext context, GoRouterState state) {
      final user = ref.read(currentUserProvider);
      final isLoggedIn = user != null;
      final location = state.matchedLocation;

      // Allow the splash screen to run its timer without redirecting.
      if (location == '/splash') return null;

      // Unauthenticated users may only visit /login and /signup.
      if (!isLoggedIn && location != '/login' && location != '/signup') {
        return '/login';
      }

      // Authenticated users are redirected away from auth screens.
      if (isLoggedIn && (location == '/login' || location == '/signup')) {
        return '/home';
      }

      return null; // No redirect needed.
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return ProductDetailScreen(productId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/favourites',
        builder: (context, state) => const FavouritesScreen(),
      ),
    ],
  );
}

/// Bridges a Dart [Stream] into a [Listenable] so go_router can re-evaluate
/// its redirect whenever the stream emits a new event.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
