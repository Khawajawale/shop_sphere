import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/permission.dart';
import '../../../../core/auth/user_role.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../catalog/presentation/providers/catalog_seed_provider.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../../routes/route_names.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final role = user?.role ?? UserRole.customer;
    final products = ref.watch(productControllerProvider).allProducts;
    final orders = ref.watch(ordersControllerProvider);

    if (!PermissionChecker.can(role, AppPermission.viewAdminPanel)) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Access Denied'),
        ),
        body: const Center(
          child: Text(
            'You do not have permission to access the admin panel.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          _StatCard(
            title: 'Total Products',
            value: '${products.length}',
            icon: Icons.inventory_2_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSizes.md),
          _StatCard(
            title: 'Total Orders',
            value: '${orders.length}',
            icon: Icons.receipt_long_outlined,
            color: Colors.green,
          ),
          const SizedBox(height: AppSizes.md),
          _StatCard(
            title: 'Your Role',
            value: role.value.toUpperCase(),
            icon: Icons.admin_panel_settings_outlined,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: AppSizes.lg),
          const Text(
            'Management',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          _CatalogSeedTile(
            enabled: PermissionChecker.can(role, AppPermission.manageUsers),
          ),
          _AdminTile(
            icon: Icons.shopping_bag_outlined,
            title: 'Manage Products',
            enabled: PermissionChecker.can(role, AppPermission.manageProducts),
            subtitle: 'Add, edit, and remove catalog items',
            onTap: () => context.push(RouteNames.adminProducts),
          ),
          _AdminTile(
            icon: Icons.local_shipping_outlined,
            title: 'Manage Orders',
            enabled: PermissionChecker.can(role, AppPermission.manageOrders),
            subtitle: 'Track and update order statuses',
          ),
          _AdminTile(
            icon: Icons.people_outline,
            title: 'Manage Users',
            enabled: PermissionChecker.can(role, AppPermission.manageUsers),
            subtitle: 'Assign roles and manage accounts',
          ),
          _AdminTile(
            icon: Icons.campaign_outlined,
            title: 'Manage Promotions',
            enabled: PermissionChecker.can(role, AppPermission.managePromotions),
            subtitle: 'Configure banners and discount campaigns',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.cardRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSizes.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CatalogSeedTile extends ConsumerStatefulWidget {
  final bool enabled;

  const _CatalogSeedTile({required this.enabled});

  @override
  ConsumerState<_CatalogSeedTile> createState() => _CatalogSeedTileState();
}

class _CatalogSeedTileState extends ConsumerState<_CatalogSeedTile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(catalogSeedControllerProvider.notifier).refreshRemoteCount(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seedState = ref.watch(catalogSeedControllerProvider);
    final remoteCount = seedState.remoteCount;

    return Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSizes.cardRadius,
        ),
        child: ListTile(
          leading: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
          title: const Text(
            'Seed Firestore Catalog',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            remoteCount == null
                ? 'Upload 15 demo products to Firestore'
                : 'Firestore products: $remoteCount • tap to (re)seed',
          ),
          trailing: seedState.isSeeding
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right_rounded),
          onTap: !widget.enabled || seedState.isSeeding
              ? null
              : () async {
                  final notifier =
                      ref.read(catalogSeedControllerProvider.notifier);
                  final success = await notifier.seedCatalog();

                  if (!context.mounted) return;

                  await ref
                      .read(productControllerProvider.notifier)
                      .loadHomeProducts();

                  if (!context.mounted) return;

                  final updated = ref.read(catalogSeedControllerProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? updated.message ?? 'Catalog seeded.'
                            : updated.error ?? 'Seed failed.',
                      ),
                      backgroundColor:
                          success ? Colors.green : Colors.red.shade700,
                    ),
                  );
                },
        ),
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  const _AdminTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSizes.cardRadius,
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: enabled ? onTap : null,
        ),
      ),
    );
  }
}
