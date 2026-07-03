import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/onboarding_data.dart';
import '../controllers/onboarding_controller.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_card.dart';
import '../widgets/next_button.dart';
import '../widgets/skip_button.dart';
import '../widgets/page_indicator.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() =>
      _OnboardingPageState();
}

class _OnboardingPageState
    extends ConsumerState<OnboardingPage> {
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

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: SkipButton(
                onPressed: () {
                  controller.jumpToLastPage();
                },
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: onboardingPages.length,

                onPageChanged: (index) {
                  ref.read(currentPageProvider.notifier).state =
                      index;
                },

                itemBuilder: (_, index) {
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: NextButton(
                text: currentPage == 2
                    ? "Get Started"
                    : "Next",

                onPressed: () {

                  if (currentPage == 2) {

                    // SharedPreferences
                    // Navigate Login

                  } else {

                    controller.nextPage(currentPage);

                  }
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}