// Supabase database service for the favourites table.
// All reads, inserts and deletes use the signed-in user's RLS policies,
// so no service-role key is ever needed here.

import 'package:shoplite/core/errors/app_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouritesService {
  final SupabaseClient _db;

  FavouritesService(this._db);

  // Convenience getter for the authenticated user's ID.
  String get _userId {
    final user = _db.auth.currentUser;
    if (user == null) throw const AppException('You must be logged in.');
    return user.id;
  }

  /// Returns the list of product IDs that this user has saved.
  Future<List<int>> fetchFavouriteIds() async {
    try {
      final rows = await _db
          .from('favourites')
          .select('product_id')
          .eq('user_id', _userId);
      return (rows as List<dynamic>)
          .map((r) => (r as Map<String, dynamic>)['product_id'] as int)
          .toList();
    } catch (e) {
      throw AppException('Could not load favourites: $e');
    }
  }

  /// Returns the total number of favourites for the current user.
  Future<int> fetchFavouriteCount() async {
    try {
      final rows = await _db
          .from('favourites')
          .select('id')
          .eq('user_id', _userId);
      return (rows as List<dynamic>).length;
    } catch (e) {
      throw AppException('Could not count favourites: $e');
    }
  }

  /// Adds [productId] to the user's favourites.
  Future<void> addFavourite(int productId) async {
    try {
      await _db.from('favourites').insert({
        'user_id': _userId,
        'product_id': productId,
      });
    } catch (e) {
      throw AppException('Could not add favourite: $e');
    }
  }

  /// Removes [productId] from the user's favourites.
  Future<void> removeFavourite(int productId) async {
    try {
      await _db
          .from('favourites')
          .delete()
          .eq('user_id', _userId)
          .eq('product_id', productId);
    } catch (e) {
      throw AppException('Could not remove favourite: $e');
    }
  }
}
