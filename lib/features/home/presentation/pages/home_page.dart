import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/search/app_search_bar.dart';
import '../../../../routes/route_names.dart';
import '../../../../core/services/release_monitoring_service.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../notifications/presentation/providers/notifications_provider.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/selected_category_provider.dart';
import '../widgets/category_section/category_section.dart';
import '../widgets/continue_shopping_section.dart';
import '../widgets/featured_products/featured_products_section.dart';
import '../widgets/home_app_bar/home_app_bar.dart';
import '../widgets/home_banner/home_banner.dart';
import '../widgets/product_horizontal_list.dart';
import '../providers/product_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _sessionLogged = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(authControllerProvider.notifier).loadCurrentUser();
      await ref.read(productControllerProvider.notifier).loadHomeProducts();

      final user = ref.read(authControllerProvider).user;
      if (user != null) {
        await ref
            .read(ordersControllerProvider.notifier)
            .syncFromRemote(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final authState = ref.watch(authControllerProvider);
    final cartCount = ref.watch(cartItemCountProvider);
    final notificationCount = ref.watch(unreadNotificationsCountProvider);
    final userName = authState.user?.name ?? 'Guest';

    if (!_sessionLogged) {
      _sessionLogged = true;
      ReleaseMonitoringService.onSessionReady(entryPoint: 'home');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(productControllerProvider.notifier).loadHomeProducts();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: AnimatedSection(
                  child: HomeAppBar(
                    userName: userName,
                    cartItemCount: cartCount,
                    notificationCount: notificationCount,
                    onNotificationPressed: () {
                      context.push(RouteNames.notifications);
                    },
                    onCartPressed: () => context.go('/cart'),
                    onProfilePressed: () => context.go('/profile'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 80),
                  child: GestureDetector(
                    onTap: () => context.push(RouteNames.search),
                    child: const AbsorbPointer(
                      child: AppSearchBar(readOnly: true),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 160),
                  child: const HomeBanner(),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 240),
                  child: CategorySection(
                    selectedCategoryId: selectedCategory,
                    onCategorySelected: (id) {
                      ref.read(selectedCategoryProvider.notifier).state = id;
                    },
                    onSeeAll: () {},
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 320),
                  child: const FeaturedProductsSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final productState = ref.watch(productControllerProvider);
                    final bestSellers = productState.allProducts
                        .where((p) => p.rating >= 4.5)
                        .toList();
                    return AnimatedSection(
                      delay: const Duration(milliseconds: 380),
                      child: ProductHorizontalList(
                        title: 'Best Sellers',
                        subtitle: 'Most popular choices among shoppers',
                        products: bestSellers,
                        onSeeAll: () {},
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final productState = ref.watch(productControllerProvider);
                    final recentlyAdded = List.from(productState.allProducts);
                    recentlyAdded.sort(
                      (a, b) => b.createdAt.compareTo(a.createdAt),
                    );
                    return AnimatedSection(
                      delay: const Duration(milliseconds: 440),
                      child: ProductHorizontalList(
                        title: 'Recently Added',
                        subtitle: 'Fresh arrivals straight to the store',
                        products: recentlyAdded.take(5).toList(),
                        onSeeAll: () {},
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final productState = ref.watch(productControllerProvider);
                    final recommended = productState.allProducts
                        .where((p) => !p.featured)
                        .toList();
                    return AnimatedSection(
                      delay: const Duration(milliseconds: 500),
                      child: ProductHorizontalList(
                        title: 'Recommended For You',
                        subtitle: 'Based on your interest profile',
                        products: recommended,
                        onSeeAll: () {},
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 560),
                  child: const ContinueShoppingSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
