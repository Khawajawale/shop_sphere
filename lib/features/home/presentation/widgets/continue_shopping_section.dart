import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recently_viewed_provider.dart';
import 'product_horizontal_list.dart';

class ContinueShoppingSection extends ConsumerWidget {
  const ContinueShoppingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(recentlyViewedProductsProvider);

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return ProductHorizontalList(
      title: 'Continue Shopping',
      subtitle: 'Pick up where you left off',
      products: products,
      onSeeAll: () {},
    );
  }
}
