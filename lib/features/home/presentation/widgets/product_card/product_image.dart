import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

class ProductImage extends StatefulWidget {
  final List<String> images;
  final bool outOfStock;
  final double height;

  const ProductImage({
    super.key,
    required this.images,
    required this.outOfStock,
    this.height = AppSizes.productImageHeight,
  });

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: widget.images.isNotEmpty
              ? widget.images.first
              : 'product_placeholder',
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: SizedBox(
              height: widget.height,
              width: double.infinity,
              child: widget.images.isEmpty
                  ? _placeholder()
                  : RepaintBoundary(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: Colors.grey.shade100),
                          CachedNetworkImage(
                            imageUrl: widget.images.first,
                            fit: BoxFit.cover,
                            memCacheWidth: 600,
                            placeholder: (_, _) => _loadingPlaceholder(),
                            errorWidget: (_, _, _) => _placeholder(),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        if (widget.outOfStock)
          Positioned.fill(
            child: Semantics(
              label: 'Out of stock',
              child: Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'OUT OF STOCK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade100,
            Colors.grey.shade200,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey,
          size: 52,
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 60,
        ),
      ),
    );
  }
}
