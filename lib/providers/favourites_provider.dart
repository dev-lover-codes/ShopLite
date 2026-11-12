// Riverpod providers for favourites management.
// favouritesServiceProvider: creates a FavouritesService per auth session.
// favouriteIdsProvider: holds the list of saved product IDs (AsyncValue).
// FavouritesNotifier: adds and removes favourites and updates local state
//   immediately so the UI responds without waiting for a network round-trip.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/data/models/product.dart';
import 'package:shoplite/data/services/favourites_service.dart';
import 'package:shoplite/providers/products_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Creates a [FavouritesService] backed by the Supabase singleton.
final favouritesServiceProvider = Provider<FavouritesService>((ref) {
  return FavouritesService(Supabase.instance.client);
});

// ---------------------------------------------------------------------------
// FavouritesNotifier — manages the in-memory list of saved product IDs
// ---------------------------------------------------------------------------

/// An [AsyncNotifier] that holds the set of favourite product IDs.
/// Calling [add] or [remove] optimistically updates the UI before the
/// database call completes, then refreshes from the server on completion.
class FavouritesNotifier extends AsyncNotifier<List<int>> {
  @override
  Future<List<int>> build() async {
    // Load the initial list from Supabase when the provider is first read.
    return ref.read(favouritesServiceProvider).fetchFavouriteIds();
  }

  /// Adds [productId] to favourites (optimistic update).
  Future<void> add(int productId) async {
    // Optimistically add to the current list before the server call.
    final previous = state.valueOrNull ?? [];
    state = AsyncData([...previous, productId]);
    try {
      await ref.read(favouritesServiceProvider).addFavourite(productId);
    } catch (e) {
      // Roll back on failure.
      state = AsyncData(previous);
      rethrow;
    }
  }

  /// Removes [productId] from favourites (optimistic update).
  Future<void> remove(int productId) async {
    final previous = state.valueOrNull ?? [];
    state = AsyncData(previous.where((id) => id != productId).toList());
    try {
      await ref.read(favouritesServiceProvider).removeFavourite(productId);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  /// Reloads the list from Supabase.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(favouritesServiceProvider).fetchFavouriteIds(),
    );
  }
}

/// The main favourites provider. Widgets watch this for the current list.
final favouritesProvider = AsyncNotifierProvider<FavouritesNotifier, List<int>>(
  FavouritesNotifier.new,
);

// ---------------------------------------------------------------------------
// Derived provider: full Product objects for the favourites list
// ---------------------------------------------------------------------------

/// Fetches full [Product] objects for each saved product ID in parallel.
final favouriteProductsProvider = FutureProvider<List<Product>>((ref) async {
  final ids = await ref.watch(favouritesProvider.future);
  final service = ref.watch(productApiServiceProvider);
  // Fetch all products in parallel.
  final results = await Future.wait(ids.map(service.fetchProduct));
  return results;
});
