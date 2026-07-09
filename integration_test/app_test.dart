import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shop_sphere/features/splash/presentation/pages/splash_page.dart';

/// Integration tests run on a device or emulator.
/// Full E2E flows require Firebase configuration and a signed-in session.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ShopSphere smoke tests', () {
    testWidgets('splash screen displays ShopSphere branding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );

      expect(find.text('ShopSphere'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
