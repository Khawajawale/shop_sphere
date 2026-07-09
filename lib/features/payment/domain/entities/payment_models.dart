enum PaymentStatus {
  requiresPaymentMethod,
  processing,
  succeeded,
  failed,
}

extension PaymentStatusX on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.requiresPaymentMethod:
        return 'requires_payment_method';
      case PaymentStatus.processing:
        return 'processing';
      case PaymentStatus.succeeded:
        return 'succeeded';
      case PaymentStatus.failed:
        return 'failed';
    }
  }

  static PaymentStatus fromValue(String value) {
    switch (value) {
      case 'processing':
        return PaymentStatus.processing;
      case 'succeeded':
        return PaymentStatus.succeeded;
      case 'failed':
        return PaymentStatus.failed;
      default:
        return PaymentStatus.requiresPaymentMethod;
    }
  }
}

class PaymentIntent {
  final String paymentId;
  final String clientSecret;
  final double amount;
  final String currency;

  const PaymentIntent({
    required this.paymentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
  });
}

class PaymentResult {
  final PaymentStatus status;
  final String? failureReason;
  final String? last4;
  final String? cardBrand;
  final String paymentId;

  const PaymentResult({
    required this.status,
    required this.paymentId,
    this.failureReason,
    this.last4,
    this.cardBrand,
  });

  bool get isSuccess => status == PaymentStatus.succeeded;
}

class SandboxCardDetails {
  final String cardNumber;
  final String expMonth;
  final String expYear;
  final String cvc;

  const SandboxCardDetails({
    required this.cardNumber,
    required this.expMonth,
    required this.expYear,
    required this.cvc,
  });
}
