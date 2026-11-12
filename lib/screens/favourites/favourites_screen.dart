// Favourites screen. Loads the user's saved product IDs from Supabase,
// then fetches each full product from the FakeStore API.
// Removing a favourite updates the list immediately without a full reload.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shoplite/providers/favourites_provider.dart';
import 'package:shoplite/widgets/app_scaffold.dart';
import 'package:shoplite/widgets/empty_view.dart';
import 'package:shoplite/widgets/error_view.dart';
import 'package:shoplite/widgets/loading_view.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteProductsAsync = ref.watch(favouriteProductsProvider);

    return AppScaffold(
      title: 'My Favourites',
      body: favouriteProductsAsync.when(
        loading: () => const LoadingView(message: 'Loading favourites…'),
        error: (err, _) => ErrorView(
          message: err.toString(),
          onRetry: () => ref.invalidate(favouriteProductsProvider),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const EmptyView(
              message:
                  'No favourites yet.\nBrowse products and tap the ♡ to save them here.',
              icon: Icons.favorite_border,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  // Thumbnail image
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                  title: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Navigate to details on tap
                  onTap: () => context.push('/products/${product.id}'),
                  // Remove button on the trailing side
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    tooltip: 'Remove from favourites',
                    onPressed: () async {
                      try {
                        await ref
                            .read(favouritesProvider.notifier)
                            .remove(product.id);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
