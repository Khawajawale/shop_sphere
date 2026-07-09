import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/payment_models.dart';
import '../utils/sandbox_payment_utils.dart';

class PaymentRemoteDataSource {
  final FirebaseFunctions _functions;

  PaymentRemoteDataSource({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    String currency = 'usd',
    String? orderId,
  }) async {
    try {
      final callable = _functions.httpsCallable('createPaymentIntent');
      final result = await callable.call<Map<String, dynamic>>({
        'amount': amount,
        'currency': currency,
        'orderId': ?orderId,
      });

      final data = Map<String, dynamic>.from(result.data);
      return PaymentIntent(
        paymentId: data['paymentId'] as String,
        clientSecret: data['clientSecret'] as String,
        amount: amount,
        currency: currency,
      );
    } catch (_) {
      if (kDebugMode) {
        return _createLocalIntent(amount: amount, currency: currency);
      }
      throw FirebaseFunctionsException(
        code: 'unavailable',
        message: 'Payment service is unavailable.',
      );
    }
  }

  Future<PaymentResult> confirmSandboxPayment({
    required String paymentId,
    required SandboxCardDetails card,
  }) async {
    try {
      final callable = _functions.httpsCallable('confirmSandboxPayment');
      final result = await callable.call<Map<String, dynamic>>({
        'paymentId': paymentId,
        'cardNumber': card.cardNumber,
        'expMonth': card.expMonth,
        'expYear': card.expYear,
        'cvc': card.cvc,
      });

      final data = Map<String, dynamic>.from(result.data);
      return PaymentResult(
        paymentId: paymentId,
        status: PaymentStatusX.fromValue(data['status'] as String? ?? 'failed'),
        failureReason: data['failureReason'] as String?,
        last4: data['last4'] as String?,
        cardBrand: data['cardBrand'] as String?,
      );
    } catch (_) {
      if (kDebugMode) {
        return _confirmLocalPayment(paymentId: paymentId, card: card);
      }
      throw FirebaseFunctionsException(
        code: 'unavailable',
        message: 'Payment service is unavailable.',
      );
    }
  }

  PaymentIntent _createLocalIntent({
    required double amount,
    String currency = 'usd',
  }) {
    final paymentId = 'local_${DateTime.now().millisecondsSinceEpoch}';
    return PaymentIntent(
      paymentId: paymentId,
      clientSecret: 'local_secret_$paymentId',
      amount: amount,
      currency: currency,
    );
  }

  Future<PaymentResult> _confirmLocalPayment({
    required String paymentId,
    required SandboxCardDetails card,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final status = evaluateSandboxCardLocally(card.cardNumber);
    final normalized = normalizeCardNumber(card.cardNumber);

    return PaymentResult(
      paymentId: paymentId,
      status: status,
      failureReason: status == PaymentStatus.failed
          ? sandboxFailureReason(card.cardNumber)
          : null,
      last4: normalized.length >= 4 ? normalized.substring(normalized.length - 4) : null,
      cardBrand: detectCardBrand(card.cardNumber),
    );
  }
}
