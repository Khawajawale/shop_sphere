import '../../domain/entities/payment_models.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    String currency = 'usd',
    String? orderId,
  }) {
    return remoteDataSource.createPaymentIntent(
      amount: amount,
      currency: currency,
      orderId: orderId,
    );
  }

  @override
  Future<PaymentResult> confirmSandboxPayment({
    required String paymentId,
    required SandboxCardDetails card,
  }) {
    return remoteDataSource.confirmSandboxPayment(
      paymentId: paymentId,
      card: card,
    );
  }
}
