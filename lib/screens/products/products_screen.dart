// Products list screen. Fetches all products from the FakeStore API,
// lets the user search by title, and filter by category chip.
// A responsive grid adapts from 2 columns on small phones to 4 on tablets.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/providers/favourites_provider.dart';
import 'package:shoplite/providers/products_provider.dart';
import 'package:shoplite/widgets/app_scaffold.dart';
import 'package:shoplite/widgets/category_chips.dart';
import 'package:shoplite/widgets/empty_view.dart';
import 'package:shoplite/widgets/error_view.dart';
import 'package:shoplite/widgets/loading_view.dart';
import 'package:shoplite/widgets/product_card.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _selectedCategory;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final favouriteIds = ref.watch(favouritesProvider).valueOrNull ?? [];

    return AppScaffold(
      title: 'Products',
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search products…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),

          // Category filter chips
          categoriesAsync.when(
            data: (cats) => CategoryChips(
              categories: cats,
              selected: _selectedCategory,
              onSelected: (cat) => setState(() => _selectedCategory = cat),
            ),
            loading: () => const SizedBox(height: 48),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 8),

          // Product grid
          Expanded(
            child: productsAsync.when(
              loading: () => const LoadingView(message: 'Loading products…'),
              error: (err, _) => ErrorView(
                message: err.toString(),
                onRetry: () => ref.invalidate(productsProvider),
              ),
              data: (products) {
                // Apply search and category filters.
                final filtered = products.where((p) {
                  final matchesQuery =
                      _query.isEmpty || p.title.toLowerCase().contains(_query);
                  final matchesCat =
                      _selectedCategory == null ||
                      p.category == _selectedCategory;
                  return matchesQuery && matchesCat;
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyView(
                    message:
                        'No products found.\nTry a different search or category.',
                    icon: Icons.search_off,
                  );
                }

                // Determine column count based on available width.
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final columns = width < 480
                        ? 2
                        : width < 720
                        ? 3
                        : 4;

                    return RefreshIndicator(
                      onRefresh: () async => ref.invalidate(productsProvider),
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          // Taller tiles for the image + text layout.
                          childAspectRatio: 0.68,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          return ProductCard(
                            product: product,
                            isFavourite: favouriteIds.contains(product.id),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
