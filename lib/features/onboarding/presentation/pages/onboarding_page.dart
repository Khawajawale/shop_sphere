import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere/routes/route_names.dart';
import '../../data/models/onboarding_data.dart';
import '../controllers/onboarding_controller.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/next_button.dart';
import '../widgets/onboarding_card.dart';
import '../widgets/page_indicator.dart';
import '../widgets/skip_button.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() =>
      _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final OnboardingController controller;

  @override
  void initState() {
    super.initState();
    controller = OnboardingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    context.go(RouteNames.login);
  }

  Future<void> _onNextPressed(int currentPage) async {
    final isLastPage = currentPage == onboardingPages.length - 1;

    if (isLastPage) {
      _goToLogin();
    } else {
      controller.nextPage(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: SkipButton(
                  onPressed: _goToLogin,
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) {
                  ref.read(currentPageProvider.notifier).state = index;
                },
                itemBuilder: (context, index) {
                  final page = onboardingPages[index];

                  return OnboardingCard(
                    image: page.image,
                    title: page.title,
                    subtitle: page.subtitle,
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                (index) => PageIndicator(
                  isActive: currentPage == index,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: NextButton(
                text: currentPage == onboardingPages.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: () => _onNextPressed(currentPage),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}