import '../entities/payment_models.dart';

abstract class PaymentRepository {
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    String currency,
    String? orderId,
  });

  Future<PaymentResult> confirmSandboxPayment({
    required String paymentId,
    required SandboxCardDetails card,
  });
}
