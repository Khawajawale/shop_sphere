import 'package:flutter_test/flutter_test.dart';

import 'package:shop_sphere/core/security/input_validators.dart';
import 'package:shop_sphere/core/security/safe_error_message.dart';

void main() {
  group('InputValidators', () {
    test('rejects overlong search query', () {
      final long = 'a' * 100;
      expect(InputValidators.validateSearchQuery(long), isNotNull);
    });

    test('rejects invalid product id', () {
      expect(InputValidators.validateProductId('../etc/passwd'), isNotNull);
    });

    test('clamps search query', () {
      final long = 'a' * 100;
      expect(InputValidators.clampSearchQuery(long).length, 80);
    });
  });

  group('SafeErrorMessage', () {
    test('hides firebase internals', () {
      expect(
        SafeErrorMessage.from(Exception('FirebaseException: permission-denied')),
        SafeErrorMessage.permissionDenied,
      );
    });

    test('allows safe user-facing auth messages', () {
      expect(
        SafeErrorMessage.from(Exception('Incorrect password.')),
        'Incorrect password.',
      );
    });
  });
}
