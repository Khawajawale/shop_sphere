import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/validators/auth_validators.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    await ref
        .read(authControllerProvider.notifier)
        .forgotPassword(
          email: emailController.text.trim(),
        );

    if (!mounted) return;

    final authState = ref.read(authControllerProvider);

    if (authState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.errorMessage!),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password reset email sent successfully.',
        ),
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    final isCompact =
        MediaQuery.of(context).size.height < 760;

    return AuthScaffold(
      title: 'Forgot Password',
      subtitle:
          'Enter your email and we will send you a password reset link.',

      footerText: 'Remember your password? ',
      footerActionText: 'Sign In',

      onFooterPressed: () {
        context.pop();
      },

      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AuthTextField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType:
                  TextInputType.emailAddress,
              validator:
                  AuthValidators.validateEmail,
            ),

            SizedBox(
              height: isCompact ? 20 : 28,
            ),

            PrimaryAuthButton(
              text: 'Send Reset Link',
              isLoading: authState.isLoading,
              onPressed: sendResetEmail,
            ),
          ],
        ),
      ),
    );
  }
}