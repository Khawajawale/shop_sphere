import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/route_names.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';
import '../../../../core/validators/auth_validators.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await ref.read(authControllerProvider.notifier).login(
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

    if (authState.isAuthenticated) {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    final isCompact =
        MediaQuery.of(context).size.height < 760;

    return AuthScaffold(
      title: 'Welcome Back',
      subtitle:
          'Sign in to continue shopping with ShopSphere.',

      footerText: "Don't have an account? ",
      footerActionText: 'Create Account',

      onFooterPressed: () {
        context.push(RouteNames.register);
      },

      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AuthTextField(
              controller: emailController,
              label: 'Email Address',
              hint: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidators.validateEmail,
            ),

            SizedBox(height: isCompact ? 14 : 20),

            AuthPasswordField(
              controller: passwordController,
              label: 'Password',
              hint: 'Enter your password',
              validator: AuthValidators.validatePassword,
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.push(RouteNames.forgotPassword);
                },
                child: const Text(
                  'Forgot Password?',
                ),
              ),
            ),

            SizedBox(height: isCompact ? 6 : 12),

            PrimaryAuthButton(
              text: 'Sign In',
              isLoading: authState.isLoading,
              height: isCompact ? 54 : 58,
              onPressed: login,
            ),
          ],
        ),
      ),
    );
  }
}