import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

enum AddToCartState {
  idle,
  loading,
  added,
  outOfStock,
}

class AddToCartButton extends StatelessWidget {
  final AddToCartState state;
  final VoidCallback? onPressed;

  const AddToCartButton({
    super.key,
    required this.state,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled =
        state != AddToCartState.loading &&
        state != AddToCartState.outOfStock;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: ElevatedButton.icon(
          key: ValueKey(state),
          onPressed: enabled ? onPressed : null,
          icon: _buildIcon(),
          label: Text(_buildText()),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: _backgroundColor(),
            disabledBackgroundColor: _backgroundColor(),
            shape: RoundedRectangleBorder(
              borderRadius: AppSizes.mediumRadius,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (state) {
      case AddToCartState.loading:
        return const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        );

      case AddToCartState.added:
        return const Icon(Icons.check_circle);

      case AddToCartState.outOfStock:
        return const Icon(Icons.block);

      case AddToCartState.idle:
        return const Icon(Icons.shopping_cart_outlined);
    }
  }

  String _buildText() {
    switch (state) {
      case AddToCartState.loading:
        return 'Adding...';

      case AddToCartState.added:
        return 'Added';

      case AddToCartState.outOfStock:
        return 'Out of Stock';

      case AddToCartState.idle:
        return 'Add to Cart';
    }
  }

  Color _backgroundColor() {
    switch (state) {
      case AddToCartState.loading:
        return AppColors.primary;

      case AddToCartState.added:
        return AppColors.success;

      case AddToCartState.outOfStock:
        return Colors.grey;

      case AddToCartState.idle:
        return AppColors.primary;
    }
  }
}