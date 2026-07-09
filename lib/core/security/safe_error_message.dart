/// Maps exceptions to user-safe messages. Never expose stack traces or internals.
class SafeErrorMessage {
  SafeErrorMessage._();

  static const generic =
      'Something went wrong. Please try again.';
  static const authFailed =
      'Authentication failed. Please try again.';
  static const network =
      'Please check your internet connection.';
  static const permissionDenied =
      'You do not have permission to perform this action.';
  static const paymentFailed =
      'Payment could not be processed. Please try again.';
  static const catalogSeedFailed =
      'Unable to seed catalog. Please try again.';

  static String from(Object error, {String fallback = generic}) {
    final message = error.toString();

    if (message.contains('network-request-failed') ||
        message.contains('SocketException') ||
        message.contains('NetworkException')) {
      return network;
    }

    if (message.contains('permission-denied') ||
        message.contains('PERMISSION_DENIED')) {
      return permissionDenied;
    }

    if (message.startsWith('Exception: ')) {
      final inner = message.substring('Exception: '.length);
      if (_isSafeUserMessage(inner)) return inner;
      return fallback;
    }

    if (error is String && _isSafeUserMessage(error)) {
      return error;
    }

    return fallback;
  }

  static bool _isSafeUserMessage(String message) {
    if (message.isEmpty || message.length > 200) return false;
    final lower = message.toLowerCase();
    const blocked = [
      'stacktrace',
      'firebase',
      'firestore',
      'cloud_firestore',
      'platformexception',
      'dart:',
      'package:',
      'lib/',
      'null check',
      'assertion',
      'internal',
      'sql',
      'column',
    ];
    for (final token in blocked) {
      if (lower.contains(token)) return false;
    }
    return true;
  }
}
