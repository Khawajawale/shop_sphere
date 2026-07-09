import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../home/domain/entities/product.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../../home/presentation/providers/recently_viewed_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;
  bool _descriptionExpanded = false;
  int _activeImageIndex = 0;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Carbon Black', 'color': const Color(0xFF1E1E1E)},
    {'name': 'Steel Grey', 'color': const Color(0xFF8E8E93)},
    {'name': 'Navy Blue', 'color': const Color(0xFF0F1E36)},
    {'name': 'Alabaster White', 'color': const Color(0xFFF2F2F7)},
  ];

  @override
  void initState() {
    super.initState();
    _selectedSize = _sizes[1];
    _selectedColor = _colors[0]['name'] as String;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recentlyViewedControllerProvider.notifier)
          .trackProduct(widget.productId);

      ref.read(productByIdProvider(widget.productId).future).then((product) {
        if (product != null && mounted) {
          AnalyticsService.logViewItem(
            itemId: product.id,
            itemName: product.name,
            category: product.categoryId,
            price: product.currentPrice,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return productAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: AppLoader()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('Unable to load product. Please try again.'),
        ),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Product not found.')),
          );
        }
        return _buildContent(context, product);
      },
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    final isFavorite = ref.watch(wishlistControllerProvider).contains(product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // PREMIUM SLIVER APP BAR
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                onPressed: () => context.pop(),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                    color: isFavorite ? Colors.red : AppColors.textPrimary,
                    size: 20,
                  ),
                  onPressed: () {
                    ref.read(wishlistControllerProvider.notifier).toggleFavorite(product.id);
                  },
                ),
              ),
              const SizedBox(width: AppSizes.md),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (index) {
                      setState(() => _activeImageIndex = index);
                    },
                    itemCount: product.images.isNotEmpty ? product.images.length : 1,
                    itemBuilder: (context, index) {
                      return product.images.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.images[index],
                              fit: BoxFit.cover,
                              placeholder: (_, _) => Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              errorWidget: (_, _, _) => Container(
                                color: Colors.grey.shade100,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade100,
                              child: const Icon(Icons.image, size: 48, color: Colors.grey),
                            );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.images.isNotEmpty ? product.images.length : 1,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _activeImageIndex == index
                                ? AppColors.primary
                                : Colors.white60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PRODUCT INFO CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RATING & STOCK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F5F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating} ',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '(${product.reviewCount} Reviews)',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: product.inStock ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.inStock ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color: product.inStock ? Colors.green.shade700 : Colors.red.shade700,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),

                  // NAME
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),

                  // DESCRIPTION
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.description,
                          maxLines: _descriptionExpanded ? 100 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => setState(() => _descriptionExpanded = !_descriptionExpanded),
                          child: Text(
                            _descriptionExpanded ? 'Read Less' : 'Read More',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // SIZE SELECTION
                  const Text(
                    'Select Size',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Material(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => setState(() => _selectedSize = size),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 45,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                              ),
                              child: Text(
                                size,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // COLOR SELECTION
                  const Text(
                    'Select Color',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _colors.map((c) {
                      final name = c['name'] as String;
                      final clr = c['color'] as Color;
                      final isSelected = _selectedColor == name;

                      return Container(
                        margin: const EdgeInsets.only(right: 14),
                        child: InkWell(
                          onTap: () => setState(() => _selectedColor = name),
                          borderRadius: BorderRadius.circular(100),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: clr,
                              ),
                              if (isSelected)
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // QUANTITYSELECTOR
                  const Text(
                    'Select Quantity',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQtyBtn(
                        icon: Icons.remove,
                        onTap: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                      _buildQtyBtn(
                        icon: Icons.add,
                        onTap: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAppBar(product),
    );
  }

  Widget _buildQtyBtn({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: const Color(0xFFF0F1F5),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: onTap == null ? Colors.grey : AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildBottomAppBar(dynamic product) {
    final finalPrice = product.currentPrice * _quantity;

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Price Details',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${finalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: !product.inStock
                    ? null
                    : () async {
                        await ref.read(cartControllerProvider.notifier).addItem(
                              product,
                              quantity: _quantity,
                              size: _selectedSize,
                              color: _selectedColor,
                            );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} Added to Cart!'),
                              backgroundColor: AppColors.primary,
                              action: SnackBarAction(
                                label: 'Open Cart',
                                textColor: Colors.white,
                                onPressed: () {
                                  context.go('/cart');
                                },
                              ),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_checkout_rounded, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Add To Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
