import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/permission.dart';
import '../../../../core/auth/user_role.dart';
import '../../../../core/services/app_version_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../routes/route_names.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    final displayName = user?.name ?? "Waleed";
    final displayEmail = user?.email ?? "waleed@example.com";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            // USER INFO CARD
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSizes.cardRadius,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // SETTINGS TILES
            _buildSection(
              title: 'Account Settings',
              tiles: [
                _buildTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Personal Details',
                  onTap: () => context.push(RouteNames.editProfile),
                ),
                _buildTile(
                  icon: Icons.location_on_outlined,
                  title: 'My Shipping Addresses',
                  onTap: () => context.push(RouteNames.shippingAddresses),
                ),
                _buildTile(
                  icon: Icons.payment_outlined,
                  title: 'Saved Payment Methods',
                  onTap: () => context.push(RouteNames.paymentMethods),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            _buildSection(
              title: 'Support & Security',
              tiles: [
                _buildTile(
                  icon: Icons.security_outlined,
                  title: 'Security & Change Password',
                  onTap: () => context.push(RouteNames.security),
                ),
                _buildTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Frequently Asked Questions',
                  onTap: () => context.push(RouteNames.faq),
                ),
                _buildTile(
                  icon: Icons.support_agent_outlined,
                  title: 'Contact Support Services',
                  onTap: () => context.push(RouteNames.support),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            if (PermissionChecker.can(
              user?.role ?? UserRole.customer,
              AppPermission.viewAdminPanel,
            ))
              _buildSection(
                title: 'Administration',
                tiles: [
                  _buildTile(
                    icon: Icons.dashboard_outlined,
                    title: 'Admin Dashboard',
                    onTap: () => context.push(RouteNames.admin),
                  ),
                ],
              ),

            if (PermissionChecker.can(
              user?.role ?? UserRole.customer,
              AppPermission.viewAdminPanel,
            ))
              const SizedBox(height: AppSizes.md),

            const SizedBox(height: AppSizes.lg),
            Center(
              child: Text(
                'Version ${AppVersionService.fullVersion}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFF0F0),
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFFFD5D5)),
                ),
                elevation: 0,
              ).child(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(RouteNames.login);
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Log Out Securely',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> tiles}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppSizes.cardRadius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x02000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _buildTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}

extension _ElevatedButtonExtension on ButtonStyle {
  Widget child({required VoidCallback onPressed, required Widget child}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: this,
      child: child,
    );
  }
}
