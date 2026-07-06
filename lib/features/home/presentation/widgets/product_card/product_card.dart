import 'package:flutter/material.dart';

import '../../../../../core/constants/app_shadows.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../domain/entities/product.dart';
import 'add_to_cart_button.dart';
import 'discount_badge.dart';
import 'price_section.dart';
import 'product_image.dart';
import 'rating_section.dart';
import 'wishlist_button.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlist;

  final bool isFavorite;
  final AddToCartState cartState;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onWishlist,
    this.isFavorite = false,
    this.cartState = AddToCartState.idle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: AppSizes.cardRadius,
          boxShadow:
              _pressed ? AppShadows.large : AppShadows.medium,
        ),
        child: Material(
          color: Colors.white,
          borderRadius: AppSizes.cardRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: AppSizes.cardRadius,
            onTap: widget.onTap,
            onTapDown: (_) {
              setState(() => _pressed = true);
            },
            onTapUp: (_) {
              setState(() => _pressed = false);
            },
            onTapCancel: () {
              setState(() => _pressed = false);
            },
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                //-------------------------------------------------
                // IMAGE
                //-------------------------------------------------

                Stack(
                  children: [
                    ProductImage(
                      images: widget.product.images,
                      outOfStock:
                          !widget.product.inStock,
                    ),

                    Positioned(
                      top: 10,
                      left: 10,
                      child: DiscountBadge(
                        percentage: widget
                            .product
                            .discountPercentage,
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: WishlistButton(
                        isFavorite:
                            widget.isFavorite,
                        onPressed:
                            widget.onWishlist,
                      ),
                    ),
                  ],
                ),

                //-------------------------------------------------
                // DETAILS
                //-------------------------------------------------

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      AppSizes.md,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w700,
                            height: 1.3,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(
                          height: AppSizes.sm,
                        ),

                        RatingSection(
                          rating:
                              widget.product.rating,
                          reviewCount: widget
                              .product
                              .reviewCount,
                        ),

                        const SizedBox(
                          height: AppSizes.sm,
                        ),

                        PriceSection(
                          price:
                              widget.product.price,
                          currentPrice: widget
                              .product
                              .currentPrice,
                          hasDiscount: widget
                              .product
                              .hasDiscount,
                        ),

                        const Spacer(),

                        AddToCartButton(
                          state: widget
                                  .product.inStock
                              ? widget.cartState
                              : AddToCartState
                                  .outOfStock,
                          onPressed:
                              widget.onAddToCart,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}