import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/route_names.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex =
        RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  void login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Firebase login comes in the next phase.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const AuthHeader(
                    logoPath: 'assets/images/logo.png',
                    title: 'Welcome Back',
                    subtitle:
                        'Sign in to continue shopping with ShopSphere.',
                  ),

                  const SizedBox(height: 40),

                  AuthTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),

                  const SizedBox(height: 20),

                  AuthPasswordField(
                    controller: passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    validator: passwordValidator,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push(RouteNames.forgotPassword);
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  PrimaryAuthButton(
                    text: 'Sign In',
                    onPressed: login,
                  ),

                  const SizedBox(height: 30),

                  AuthFooter(
                    text: "Don't have an account? ",
                    actionText: "Create Account",
                    onPressed: () {
                      context.push(RouteNames.register);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}