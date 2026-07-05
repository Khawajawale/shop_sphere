import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/route_names.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/primary_auth_button.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() =>
      _VerifyEmailPageState();
}

class _VerifyEmailPageState
    extends ConsumerState<VerifyEmailPage> {
  int _secondsRemaining = 0;

  Timer? _timer;

  bool get canResend => _secondsRemaining == 0;

  void _startCooldown() {
    setState(() {
      _secondsRemaining = 60;
    });

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        if (_secondsRemaining == 0) {
          timer.cancel();
        } else {
          setState(() {
            _secondsRemaining--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return AuthScaffold(
      title: 'Verify Your Email',
      subtitle:
          'We have sent a verification link to your email address.\n\n'
          'Please verify your account before continuing.',
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
            onPressed: () async {
              final router = GoRouter.of(context);
              final messenger = ScaffoldMessenger.of(context);

              final verified = await ref
                  .read(authControllerProvider.notifier)
                  .checkEmailVerification();

              if (!mounted) return;

              if (verified) {
                router.go(RouteNames.home);
                return;
              }

              messenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    'Your email is not verified yet.',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: canResend
                ? () async {
                    final messenger = ScaffoldMessenger.of(context);

                    await ref
                        .read(authControllerProvider.notifier)
                        .resendVerificationEmail();

                    if (!mounted) return;

                    final state =
                        ref.read(authControllerProvider);

                    if (state.errorMessage != null) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage!),
                        ),
                      );
                      return;
                    }

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Verification email sent successfully.',
                        ),
                      ),
                    );

                    _startCooldown();
                  }
                : null,
            icon: const Icon(Icons.refresh),
            label: Text(
              canResend
                  ? 'Resend Email'
                  : 'Resend in ${_secondsRemaining}s',
            ),
          ),

          const SizedBox(height: 16),

          TextButton.icon(
            onPressed: () async {
              final router = GoRouter.of(context);

              await ref
                  .read(authControllerProvider.notifier)
                  .logout();

              if (!mounted) return;

              router.go(RouteNames.login);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}