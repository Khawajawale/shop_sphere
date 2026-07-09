import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/payment_models.dart';
import '../../../../core/security/safe_error_message.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../data/datasources/payment_remote_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSource();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(ref.read(paymentRemoteDataSourceProvider));
});

final paymentControllerProvider =
    StateNotifierProvider<PaymentController, PaymentControllerState>((ref) {
  return PaymentController(ref);
});

class PaymentControllerState {
  final bool isProcessing;
  final String? error;
  final PaymentResult? lastResult;

  const PaymentControllerState({
    this.isProcessing = false,
    this.error,
    this.lastResult,
  });

  PaymentControllerState copyWith({
    bool? isProcessing,
    String? error,
    PaymentResult? lastResult,
  }) {
    return PaymentControllerState(
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
      lastResult: lastResult ?? this.lastResult,
    );
  }
}

class PaymentController extends StateNotifier<PaymentControllerState> {
  final Ref ref;

  PaymentController(this.ref) : super(const PaymentControllerState());

  Future<PaymentResult?> processCheckoutPayment({
    required double amount,
    required SandboxCardDetails card,
    String? orderId,
  }) async {
    state = state.copyWith(isProcessing: true, error: null);

    try {
      final repository = ref.read(paymentRepositoryProvider);
      final intent = await repository.createPaymentIntent(
        amount: amount,
        orderId: orderId,
      );

      final result = await repository.confirmSandboxPayment(
        paymentId: intent.paymentId,
        card: card,
      );

      state = state.copyWith(
        isProcessing: false,
        lastResult: result,
        error: result.isSuccess ? null : result.failureReason,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: SafeErrorMessage.paymentFailed,
      );
      return null;
    }
  }
}
