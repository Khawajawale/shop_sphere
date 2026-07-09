import 'package:flutter/material.dart';

import 'category_constants.dart';
import 'category_model.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CategoryCard({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _pressed = false;

  Widget _buildCategoryVisual() {
    final imageAsset = widget.category.imageAsset;
    final diameter = CategoryConstants.iconDiameter;

    if (imageAsset != null) {
      return ClipOval(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: Image.asset(
            imageAsset,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => Icon(
              widget.category.icon ?? Icons.category_rounded,
              color: widget.category.iconColor,
              size: 32,
            ),
          ),
        ),
      );
    }

    return Icon(
      widget.category.icon,
      color: widget.category.iconColor,
      size: 32,
    );
  }

  List<BoxShadow> _circleShadows() {
    if (widget.selected) {
      return [
        BoxShadow(
          color: CategoryConstants.selectionColor
              .withValues(alpha: 0.28),
          blurRadius: 18,
          spreadRadius: 1,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: CategoryConstants.selectionColor
              .withValues(alpha: 0.12),
          blurRadius: 32,
          spreadRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    }

    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _pressed ? 0.94 : 1.0;

    return AnimatedScale(
      duration: CategoryConstants.animationDuration,
      curve: Curves.easeOutCubic,
      scale: scale,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onHighlightChanged: (value) {
            setState(() {
              _pressed = value;
            });
          },
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: SizedBox(
            width: CategoryConstants.itemWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: CategoryConstants.animationDuration,
                  curve: Curves.easeOutCubic,
                  width: CategoryConstants.iconDiameter,
                  height: CategoryConstants.iconDiameter,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: _circleShadows(),
                  ),
                  child: _buildCategoryVisual(),
                ),

                const SizedBox(height: 8),

                AnimatedContainer(
                  duration: CategoryConstants.animationDuration,
                  curve: Curves.easeOutCubic,
                  width: widget.selected
                      ? CategoryConstants.selectionBarWidth
                      : 0,
                  height: CategoryConstants.selectionBarHeight,
                  decoration: BoxDecoration(
                    color: CategoryConstants.selectionColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                SizedBox(height: widget.selected ? 6 : 9),

                Text(
                  widget.category.title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: widget.selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: const Color(0xFF374151),
                    letterSpacing: 0.1,
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
