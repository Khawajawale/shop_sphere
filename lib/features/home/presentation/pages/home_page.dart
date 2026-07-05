import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(productControllerProvider.notifier)
          .loadHomeProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(productControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSphere'),
        centerTitle: true,
      ),
      body: Center(
        child: state.isLoading
            ? const CircularProgressIndicator()
            : Text(
                'Featured Products: ${state.featuredProducts.length}\n'
                'All Products: ${state.allProducts.length}',
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}