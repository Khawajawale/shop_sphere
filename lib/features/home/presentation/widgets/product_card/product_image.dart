import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

class ProductImage extends StatefulWidget {
  final List<String> images;
  final bool outOfStock;

  const ProductImage({
    super.key,
    required this.images,
    required this.outOfStock,
  });

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  bool _loaded = false;

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
              height: AppSizes.productImageHeight,
              width: double.infinity,
              child: widget.images.isEmpty
                  ? _placeholder()
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          color: Colors.grey.shade100,
                        ),

                        AnimatedScale(
                          scale: _loaded ? 1 : 1.08,
                          duration: const Duration(
                            milliseconds: 450,
                          ),
                          curve: Curves.easeOut,
                          child: AnimatedOpacity(
                            opacity: _loaded ? 1 : 0,
                            duration: const Duration(
                              milliseconds: 350,
                            ),
                            child: Image.network(
                              widget.images.first,
                              fit: BoxFit.cover,
                              frameBuilder: (
                                context,
                                child,
                                frame,
                                wasSynchronouslyLoaded,
                              ) {
                                if (wasSynchronouslyLoaded) {
                                  _loaded = true;
                                  return child;
                                }

                                if (frame != null && !_loaded) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      setState(() {
                                        _loaded = true;
                                      });
                                    }
                                  });
                                }

                                return child;
                              },
                              loadingBuilder: (
                                context,
                                child,
                                progress,
                              ) {
                                if (progress == null) {
                                  return child;
                                }

                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _loadingPlaceholder(),

                                    const Center(
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              errorBuilder:
                                  (_, _, _) =>
                                      _placeholder(),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),

        //----------------------------------------------------------
        // Out of Stock Overlay
        //----------------------------------------------------------

        if (widget.outOfStock)
          Positioned.fill(
            child: Container(
              color: Colors.black45,
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: const Text(
                  "OUT OF STOCK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
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