import 'package:firebase_performance/firebase_performance.dart';

/// Wraps Firebase Performance Monitoring traces for key app operations.
class PerformanceService {
  PerformanceService._();

  static Future<T> trace<T>(
    String name,
    Future<T> Function() operation, {
    Map<String, String>? attributes,
  }) async {
    final trace = FirebasePerformance.instance.newTrace(name);
    attributes?.forEach(trace.putAttribute);
    await trace.start();

    try {
      return await operation();
    } finally {
      await trace.stop();
    }
  }

  static Future<void> traceVoid(
    String name,
    Future<void> Function() operation, {
    Map<String, String>? attributes,
  }) async {
    await trace(name, () async {
      await operation();
      return null;
    }, attributes: attributes);
  }
}
