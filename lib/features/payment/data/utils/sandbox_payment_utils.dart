import '../../domain/entities/payment_models.dart';

/// Stripe-style sandbox test cards for portfolio demos.
class SandboxPaymentCards {
  static const success = '4242 4242 4242 4242';
  static const declined = '4000 0000 0000 0002';
  static const insufficientFunds = '4000 0000 0000 9995';

  static const hints = [
    (label: 'Success', number: success),
    (label: 'Declined', number: declined),
    (label: 'Insufficient funds', number: insufficientFunds),
  ];
}

String normalizeCardNumber(String cardNumber) =>
    cardNumber.replaceAll(RegExp(r'\D'), '');

PaymentStatus evaluateSandboxCardLocally(String cardNumber) {
  final normalized = normalizeCardNumber(cardNumber);

  switch (normalized) {
    case '4242424242424242':
      return PaymentStatus.succeeded;
    case '4000000000000002':
    case '4000000000009995':
      return PaymentStatus.failed;
    default:
      if (normalized.length >= 13 && normalized.length <= 19) {
        return PaymentStatus.succeeded;
      }
      return PaymentStatus.failed;
  }
}

String? sandboxFailureReason(String cardNumber) {
  final normalized = normalizeCardNumber(cardNumber);
  switch (normalized) {
    case '4000000000000002':
      return 'Your card was declined.';
    case '4000000000009995':
      return 'Insufficient funds.';
    default:
      if (normalized.length < 13 || normalized.length > 19) {
        return 'Invalid card number.';
      }
      return null;
  }
}

String detectCardBrand(String cardNumber) {
  final normalized = normalizeCardNumber(cardNumber);
  if (normalized.startsWith('4')) return 'visa';
  if (normalized.startsWith('5')) return 'mastercard';
  if (normalized.startsWith('3')) return 'amex';
  return 'sandbox';
}
