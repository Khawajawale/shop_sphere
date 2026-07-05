import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_state_provider.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/primary_auth_button.dart';

class VerifyEmailPage extends ConsumerWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return AuthScaffold(
      title: 'Verify Your Email',
      subtitle:
          'We have sent a verification link to your email address.\n\nPlease verify your account before continuing.',

      footerText: '',
      footerActionText: '',
      onFooterPressed: () {},

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            size: 90,
            color: Colors.green,
          ),

          const SizedBox(height: 24),

          PrimaryAuthButton(
            text: "I've Verified",
            isLoading: authState.isLoading,
            onPressed: () {
              // Next phase
            },
          ),

          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: () {
              // Next phase
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Resend Email"),
          ),

          const SizedBox(height: 16),

          TextButton.icon(
            onPressed: () async {
              await ref
                  .read(authControllerProvider.notifier)
                  .logout();
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}