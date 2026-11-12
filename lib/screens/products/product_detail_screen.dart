// Product detail screen. Fetches a single product by ID, shows its full
// details, and provides an Add/Remove favourite button that updates instantly.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/providers/favourites_provider.dart';
import 'package:shoplite/providers/products_provider.dart';
import 'package:shoplite/widgets/error_view.dart';
import 'package:shoplite/widgets/loading_view.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));
    final favouriteIds = ref.watch(favouritesProvider).valueOrNull ?? [];
    final isFavourite = favouriteIds.contains(productId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        actions: [
          // Favourite toggle button — updates instantly via optimistic state.
          productAsync.maybeWhen(
            data: (_) => IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isFavourite),
                  color: isFavourite ? Colors.red : null,
                ),
              ),
              tooltip: isFavourite
                  ? 'Remove from favourites'
                  : 'Add to favourites',
              onPressed: () async {
                final notifier = ref.read(favouritesProvider.notifier);
                try {
                  if (isFavourite) {
                    await notifier.remove(productId);
                  } else {
                    await notifier.add(productId);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SafeArea(
        child: productAsync.when(
          loading: () => const LoadingView(message: 'Loading product…'),
          error: (err, _) => ErrorView(
            message: err.toString(),
            onRetry: () => ref.invalidate(productDetailProvider(productId)),
          ),
          data: (product) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, _) =>
                          const Icon(Icons.broken_image_outlined, size: 80),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Category chip
                Chip(
                  label: Text(
                    product.category[0].toUpperCase() +
                        product.category.substring(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                // Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Rating row
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.ratingRate.toStringAsFixed(1)} '
                      '(${product.ratingCount} reviews)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Divider
                const Divider(),
                const SizedBox(height: 12),

                // Description heading
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                // Full description text
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),

                // Favourite button at the bottom
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: isFavourite ? Colors.red : null,
                    ),
                    label: Text(
                      isFavourite
                          ? 'Remove from favourites'
                          : 'Add to favourites',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFavourite
                          ? Theme.of(context).colorScheme.errorContainer
                          : null,
                      foregroundColor: isFavourite
                          ? Theme.of(context).colorScheme.onErrorContainer
                          : null,
                    ),
                    onPressed: () async {
                      final notifier = ref.read(favouritesProvider.notifier);
                      try {
                        if (isFavourite) {
                          await notifier.remove(productId);
                        } else {
                          await notifier.add(productId);
                        }
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
