import 'package:flutter/material.dart';

import '../../../../../core/constants/accessibility_labels.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'cart_button.dart';
import 'greeting_text.dart';
import 'notification_button.dart';

class HomeAppBar extends StatelessWidget {
  final String userName;

  final int cartItemCount;

  final int notificationCount;

  final VoidCallback? onNotificationPressed;

  final VoidCallback? onCartPressed;

  final VoidCallback? onProfilePressed;

  const HomeAppBar({
    super.key,
    required this.userName,
    this.cartItemCount = 0,
    this.notificationCount = 0,
    this.onNotificationPressed,
    this.onCartPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.md,
          AppSizes.md,
          AppSizes.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GreetingText(
                userName: userName,
              ),
            ),

            Semantics(
              label: AccessibilityLabels.openNotifications,
              button: true,
              child: NotificationButton(
                onPressed: onNotificationPressed,
                unreadCount: notificationCount,
              ),
            ),

            const SizedBox(width: AppSizes.sm),

            Semantics(
              label: AccessibilityLabels.openCart,
              button: true,
              child: CartButton(
                itemCount: cartItemCount,
                onPressed: onCartPressed,
              ),
            ),

            const SizedBox(width: AppSizes.md),

            Semantics(
              label: AccessibilityLabels.openProfile,
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: onProfilePressed,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    userName.isNotEmpty
                        ? userName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}