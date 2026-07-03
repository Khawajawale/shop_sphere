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
    final isCompact =
        MediaQuery.sizeOf(context).height < 760;

    return AnimatedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,

        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: isCompact ? 8 : 16),

                  AuthHeader(
                    logoPath: 'assets/images/logo.png',
                    title: 'Welcome Back',
                    subtitle:
                        'Sign in to continue shopping with ShopSphere.',
                    logoSize: 115,
                    logoBottomSpacing: isCompact ? 28 : 40,
                    titleFontSize: isCompact ? 28 : 30,
                    subtitleFontSize: isCompact ? 14 : 15,
                  ),

                  SizedBox(height: isCompact ? 20 : 32),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: GlassContainer(
                              padding: EdgeInsets.symmetric(
                                horizontal: isCompact ? 20 : 24,
                                vertical: isCompact ? 20 : 24,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AuthTextField(
                                      controller: emailController,
                                      label: 'Email Address',
                                      hint: 'Enter your email',
                                      prefixIcon:
                                          Icons.email_outlined,
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      validator: emailValidator,
                                    ),

                                    SizedBox(
                                      height: isCompact ? 14 : 20,
                                    ),

                                    AuthPasswordField(
                                      controller: passwordController,
                                      label: 'Password',
                                      hint: 'Enter your password',
                                      validator: passwordValidator,
                                    ),

                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () {
                                          context.push(
                                            RouteNames.forgotPassword,
                                          );
                                        },
                                        child: const Text(
                                          'Forgot Password?',
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: isCompact ? 6 : 12,
                                    ),

                                    PrimaryAuthButton(
                                      text: 'Sign In',
                                      isLoading: isLoading,
                                      height: isCompact ? 54 : 58,
                                      onPressed: login,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: isCompact ? 10 : 14),

                  AuthFooter(
                    text: "Don't have an account? ",
                    actionText: 'Create Account',
                    onPressed: () {
                      context.push(RouteNames.register);
                    },
                  ),

                  SizedBox(height: isCompact ? 12 : 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
