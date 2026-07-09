import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import 'banner_model.dart';

class BannerCard extends StatelessWidget {
  final BannerModel banner;

  const BannerCard({
    super.key,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppSizes.largeRadius,
      onTap: banner.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
        ),
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: banner.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppSizes.largeRadius,
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, 10),
              color: Color(0x22000000),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppSizes.largeRadius,
          child: Stack(
            children: [
              //--------------------------------------------------
              // Decorative background circles
              //--------------------------------------------------

              Positioned(
                top: -35,
                right: -35,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),

              Positioned(
                bottom: -45,
                left: -25,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              //--------------------------------------------------

              Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Row(
                  children: [
                    //--------------------------------------------------
                    // TEXT
                    //--------------------------------------------------

                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            banner.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              height: 1.05,
                            ),
                          ),

                          Text(
                            banner.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),

                          SizedBox(
                            height: 38,
                            child: FilledButton(
                              onPressed: banner.onTap,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 22,
                                ),
                              ),
                              child: Text(
                                banner.buttonText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: AppSizes.md),

                    //--------------------------------------------------
                    // IMAGE
                    //--------------------------------------------------

                    Expanded(
                      flex: 4,
                      child: Hero(
                        tag: banner.id,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              banner.image,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, _, _) =>
                                      const Icon(
                                Icons.shopping_bag,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}