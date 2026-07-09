import 'package:cloud_firestore/cloud_firestore.dart';

/// Parses order timestamps from Firestore or local JSON.
DateTime parseOrderDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is DateTime) return value;
  return DateTime.now();
}

/// Parses order document maps from Firestore or local cache.
Map<String, dynamic> normalizeOrderMap(Map<String, dynamic> orderMap) {
  return {
    ...orderMap,
    'createdAt': parseOrderDate(orderMap['createdAt']).toIso8601String(),
  };
}
