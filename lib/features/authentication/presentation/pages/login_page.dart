import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/animated_gradient_background.dart';
import '../../../../core/widgets/glass_container.dart';
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

  bool isLoading = false;

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

    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
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

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    // Firebase login will be connected later.

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen =
        MediaQuery.of(context).viewInsets.bottom > 0;

    return AnimatedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,

        body: SafeArea(
          child: GestureDetector(
            onTap: () =>
                FocusScope.of(context).unfocus(),

            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: keyboardOpen
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),

                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom:
                        MediaQuery.of(context)
                                .viewInsets
                                .bottom +
                            24,
                  ),

                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight - 48,
                    ),

                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          const AuthHeader(
                            logoPath:
                                'assets/images/logo.png',
                            title: "Welcome Back",
                            subtitle:
                                "Sign in to continue shopping with ShopSphere.",
                          ),

                          const SizedBox(height: 40),

                          GlassContainer(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AuthTextField(
                                    controller:
                                        emailController,
                                    label:
                                        "Email Address",
                                    hint:
                                        "Enter your email",
                                    prefixIcon:
                                        Icons.email_outlined,
                                    keyboardType:
                                        TextInputType
                                            .emailAddress,
                                    validator:
                                        emailValidator,
                                  ),

                                  const SizedBox(
                                      height: 20),

                                  AuthPasswordField(
                                    controller:
                                        passwordController,
                                    label: "Password",
                                    hint:
                                        "Enter your password",
                                    validator:
                                        passwordValidator,
                                  ),

                                  Align(
                                    alignment:
                                        Alignment
                                            .centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        context.push(
                                          RouteNames
                                              .forgotPassword,
                                        );
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 12),

                                  PrimaryAuthButton(
                                    text: "Sign In",
                                    isLoading:
                                        isLoading,
                                    onPressed: login,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),

                          AuthFooter(
                            text:
                                "Don't have an account? ",
                            actionText:
                                "Create Account",
                            onPressed: () {
                              context.push(
                                RouteNames.register,
                              );
                            },
                          ),

                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}