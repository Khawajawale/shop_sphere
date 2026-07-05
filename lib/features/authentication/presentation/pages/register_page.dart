import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/validators/auth_validators.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    await ref.read(authControllerProvider.notifier).register(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
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
          'Account created successfully!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    final isCompact =
        MediaQuery.of(context).size.height < 760;

    return AuthScaffold(
      title: 'Create Account',
      subtitle:
          'Join ShopSphere and start shopping today.',
      footerText: 'Already have an account? ',
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
              controller: nameController,
              label: 'Full Name',
              hint: 'John Doe',
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
              validator: AuthValidators.validateName,
            ),

            SizedBox(height: isCompact ? 14 : 20),

            AuthTextField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidators.validateEmail,
            ),

            SizedBox(height: isCompact ? 14 : 20),

            AuthPasswordField(
              controller: passwordController,
              label: 'Password',
              hint: 'Create password',
              validator: AuthValidators.validatePassword,
            ),

            SizedBox(height: isCompact ? 14 : 20),

            AuthPasswordField(
              controller: confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Confirm password',
              validator: (value) {
                return AuthValidators.validateConfirmPassword(
                  value,
                  passwordController.text,
                );
              },
            ),

            SizedBox(height: isCompact ? 18 : 24),

            PrimaryAuthButton(
              text: 'Create Account',
              isLoading: authState.isLoading,
              onPressed: register,
            ),
          ],
        ),
      ),
    );
  }
}