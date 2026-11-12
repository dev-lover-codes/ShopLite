// Home / Dashboard screen shown after login.
// Displays a welcome message, three summary cards, and navigation buttons.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shoplite/providers/auth_provider.dart';
import 'package:shoplite/providers/favourites_provider.dart';
import 'package:shoplite/providers/products_provider.dart';
import 'package:shoplite/widgets/summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final authService = ref.read(authServiceProvider);

    // Watch summary data for the cards.
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final favouritesAsync = ref.watch(favouritesProvider);

    // Derive display name safely.
    final name = user != null ? authService.displayName(user) : 'there';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopLite'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              // The router redirect will navigate to /login automatically.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                'Hello, $name 👋',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s your shopping overview.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Summary cards row
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.inventory_2_outlined,
                      value: productsAsync.when(
                        data: (p) => '${p.length}',
                        loading: () => '…',
                        error: (_, __) => '—',
                      ),
                      label: 'Products',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.category_outlined,
                      value: categoriesAsync.when(
                        data: (c) => '${c.length}',
                        loading: () => '…',
                        error: (_, __) => '—',
                      ),
                      label: 'Categories',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.favorite_border,
                      value: favouritesAsync.when(
                        data: (f) => '${f.length}',
                        loading: () => '…',
                        error: (_, __) => '—',
                      ),
                      label: 'Favourites',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Navigation buttons
              Text('Browse', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _NavCard(
                icon: Icons.store_outlined,
                title: 'Products',
                subtitle: 'Browse and search all products',
                onTap: () => context.push('/products'),
              ),
              const SizedBox(height: 12),
              _NavCard(
                icon: Icons.favorite_outline,
                title: 'My Favourites',
                subtitle: 'Products you have saved',
                onTap: () => context.push('/favourites'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A tappable navigation card for the Home screen.
class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
