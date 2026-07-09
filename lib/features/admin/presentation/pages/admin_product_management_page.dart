import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/permission.dart';
import '../../../../core/auth/user_role.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';
import '../../../home/data/models/product_model.dart';
import '../../../home/presentation/providers/product_provider.dart';

class AdminProductManagementPage extends ConsumerWidget {
  const AdminProductManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final role = user?.role ?? UserRole.customer;
    final products = ref.watch(productControllerProvider).allProducts;

    if (!PermissionChecker.can(role, AppPermission.manageProducts)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Manage Products')),
        body: const Center(
          child: Text('Only admins can manage products.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Manage Products',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          final created = await _showProductEditor(context);
          if (created == null || !context.mounted) return;
          await ref.read(productLocalDataSourceProvider).addProduct(created);
          await ref.read(productControllerProvider.notifier).loadHomeProducts();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products available.'))
          : ListView.separated(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppSizes.cardRadius,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppSizes.md),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: product.images.isNotEmpty
                            ? Image.network(
                                product.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              )
                            : Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image),
                              ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${product.categoryId}  •  \$${product.currentPrice.toStringAsFixed(2)}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          final updated = await _showProductEditor(
                            context,
                            existing: product is ProductModel
                                ? product
                                : ProductModel(
                                    id: product.id,
                                    name: product.name,
                                    description: product.description,
                                    price: product.price,
                                    salePrice: product.salePrice,
                                    images: product.images,
                                    categoryId: product.categoryId,
                                    inStock: product.inStock,
                                    stockQuantity: product.stockQuantity,
                                    rating: product.rating,
                                    reviewCount: product.reviewCount,
                                    featured: product.featured,
                                    createdAt: product.createdAt,
                                  ),
                          );
                          if (updated == null || !context.mounted) return;
                          await ref
                              .read(productLocalDataSourceProvider)
                              .updateProduct(updated);
                          await ref
                              .read(productControllerProvider.notifier)
                              .loadHomeProducts();
                        } else if (value == 'delete') {
                          await ref
                              .read(productLocalDataSourceProvider)
                              .deleteProduct(product.id);
                          await ref
                              .read(productControllerProvider.notifier)
                              .loadHomeProducts();
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

Future<ProductModel?> _showProductEditor(
  BuildContext context, {
  ProductModel? existing,
}) async {
  final nameController = TextEditingController(text: existing?.name ?? '');
  final descriptionController =
      TextEditingController(text: existing?.description ?? '');
  final imageController = TextEditingController(
    text: existing != null && existing.images.isNotEmpty
        ? existing.images.first
        : '',
  );
  final categoryController =
      TextEditingController(text: existing?.categoryId ?? 'electronics');
  final priceController = TextEditingController(
    text: (existing?.price ?? 0).toString(),
  );
  final salePriceController = TextEditingController(
    text: existing?.salePrice?.toString() ?? '',
  );
  final stockController = TextEditingController(
    text: (existing?.stockQuantity ?? 1).toString(),
  );
  bool featured = existing?.featured ?? false;
  bool inStock = existing?.inStock ?? true;

  return showDialog<ProductModel>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(existing == null ? 'Add Product' : 'Edit Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                  TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
                  TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
                  TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
                  TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price')),
                  TextField(controller: salePriceController, decoration: const InputDecoration(labelText: 'Sale Price (optional)')),
                  TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock Quantity')),
                  SwitchListTile(
                    value: featured,
                    onChanged: (value) => setState(() => featured = value),
                    title: const Text('Featured'),
                  ),
                  SwitchListTile(
                    value: inStock,
                    onChanged: (value) => setState(() => inStock = value),
                    title: const Text('In Stock'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final description = descriptionController.text.trim();
                  final imageUrl = imageController.text.trim();
                  final categoryId = categoryController.text.trim();
                  final price = double.tryParse(priceController.text.trim());
                  final salePriceText = salePriceController.text.trim();
                  final salePrice = salePriceText.isEmpty
                      ? null
                      : double.tryParse(salePriceText);
                  final stock = int.tryParse(stockController.text.trim()) ?? 0;

                  if (name.isEmpty ||
                      description.isEmpty ||
                      imageUrl.isEmpty ||
                      categoryId.isEmpty ||
                      price == null) {
                    return;
                  }

                  Navigator.of(dialogContext).pop(
                    ProductModel(
                      id: existing?.id ??
                          'admin-${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      description: description,
                      price: price,
                      salePrice: salePrice,
                      images: [imageUrl],
                      categoryId: categoryId,
                      inStock: inStock,
                      stockQuantity: stock,
                      rating: existing?.rating ?? 4.5,
                      reviewCount: existing?.reviewCount ?? 0,
                      featured: featured,
                      createdAt: existing?.createdAt ?? DateTime.now(),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
