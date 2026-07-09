import 'package:flutter_test/flutter_test.dart';

import 'package:shop_sphere/features/payment/data/utils/sandbox_payment_utils.dart';
import 'package:shop_sphere/features/payment/domain/entities/payment_models.dart';

void main() {
  group('Sandbox payment cards', () {
    test('success card evaluates to succeeded', () {
      expect(
        evaluateSandboxCardLocally('4242 4242 4242 4242'),
        PaymentStatus.succeeded,
      );
      expect(sandboxFailureReason('4242 4242 4242 4242'), isNull);
    });

    test('declined card evaluates to failed with reason', () {
      expect(
        evaluateSandboxCardLocally('4000 0000 0000 0002'),
        PaymentStatus.failed,
      );
      expect(
        sandboxFailureReason('4000 0000 0000 0002'),
        'Your card was declined.',
      );
    });

    test('insufficient funds card fails', () {
      expect(
        evaluateSandboxCardLocally('4000000000009995'),
        PaymentStatus.failed,
      );
      expect(
        sandboxFailureReason('4000000000009995'),
        'Insufficient funds.',
      );
    });

    test('invalid card length fails', () {
      expect(
        evaluateSandboxCardLocally('1234'),
        PaymentStatus.failed,
      );
    });

    test('detectCardBrand identifies visa', () {
      expect(detectCardBrand('4242424242424242'), 'visa');
    });
  });
}
