import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/accessibility_labels.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';

class MainNavigationPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationPage({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppShadows.large,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                indicatorColor: AppColors.primary.withValues(alpha: 0.1),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    );
                  }
                  return const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  );
                }),
                iconTheme: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const IconThemeData(
                      color: AppColors.primary,
                      size: 24,
                    );
                  }
                  return const IconThemeData(
                    color: AppColors.textSecondary,
                    size: 24,
                  );
                }),
              ),
              child: NavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                height: 65,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) => _onTap(context, index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                    tooltip: AccessibilityLabels.homeTab,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.favorite_outline),
                    selectedIcon: Icon(Icons.favorite_rounded),
                    label: 'Wishlist',
                    tooltip: AccessibilityLabels.wishlistTab,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.shopping_cart_outlined),
                    selectedIcon: Icon(Icons.shopping_cart_rounded),
                    label: 'Cart',
                    tooltip: AccessibilityLabels.cartTab,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.receipt_long_outlined),
                    selectedIcon: Icon(Icons.receipt_long_rounded),
                    label: 'Orders',
                    tooltip: AccessibilityLabels.ordersTab,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                    tooltip: AccessibilityLabels.profileTab,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
