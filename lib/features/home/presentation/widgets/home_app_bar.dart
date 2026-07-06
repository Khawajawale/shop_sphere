import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class HomeAppBar extends StatelessWidget {
  final String userName;

  const HomeAppBar({
    super.key,
    required this.userName,
  });

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    }

    if (hour < 17) {
      return 'Good Afternoon';
    }

    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.lg,
        AppSizes.md,
        AppSizes.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),

          const SizedBox(width: 4),

          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Text(
              userName.isNotEmpty
                  ? userName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}