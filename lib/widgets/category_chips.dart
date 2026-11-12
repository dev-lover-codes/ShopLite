// A horizontal scrollable row of filter chips for product categories.
// "All" is always the first chip. Selecting a chip notifies the parent
// via [onSelected]. The active chip is visually highlighted.

import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  /// The list of category strings from the API.
  final List<String> categories;

  /// The currently selected category, or null for "All".
  final String? selected;

  /// Called when the user taps a chip with the category name, or null for All.
  final ValueChanged<String?> onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final allChips = <String?>[null, ...categories];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allChips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = allChips[index];
          final label = category == null
              ? 'All'
              : category[0].toUpperCase() + category.substring(1);
          final isActive = selected == category;

          return FilterChip(
            label: Text(label),
            selected: isActive,
            onSelected: (_) => onSelected(category),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
