import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: Image.asset(
                  image,
                  width: 260,
                  height: 260,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) {
                    return const Icon(
                      Icons.image_outlined,
                      size: 200,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                    height: 1.5,
                  ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}