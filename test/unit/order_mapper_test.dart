import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_sphere/features/orders/data/utils/order_mapper.dart';

void main() {
  group('parseOrderDate', () {
    test('parses ISO string', () {
      final date = parseOrderDate('2026-03-01T10:00:00.000Z');
      expect(date.year, 2026);
      expect(date.month, 3);
    });

    test('parses Firestore Timestamp', () {
      final ts = Timestamp.fromDate(DateTime(2026, 2, 15));
      final date = parseOrderDate(ts);
      expect(date.day, 15);
      expect(date.month, 2);
    });

    test('returns now for invalid input', () {
      final before = DateTime.now();
      final date = parseOrderDate(null);
      final after = DateTime.now();
      expect(date.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
      expect(date.isBefore(after.add(const Duration(seconds: 1))), isTrue);
    });
  });

  group('normalizeOrderMap', () {
    test('converts Timestamp createdAt to ISO string', () {
      final ts = Timestamp.fromDate(DateTime(2026, 1, 1));
      final normalized = normalizeOrderMap({
        'id': 'ORD-1',
        'createdAt': ts,
      });

      expect(normalized['createdAt'], isA<String>());
      expect(normalized['createdAt'], contains('2026'));
    });
  });
}
