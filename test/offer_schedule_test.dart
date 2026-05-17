import 'package:flutter_test/flutter_test.dart';

import 'package:business_dashboard/features/offers/data/offer_schedule.dart';
import 'package:business_dashboard/features/offers/domain/entities/offer.dart';

void main() {
  group('OfferSchedule', () {
    test('clampDays enforces 1..30', () {
      expect(OfferSchedule.clampDays(0), 1);
      expect(OfferSchedule.clampDays(7), 7);
      expect(OfferSchedule.clampDays(99), 30);
    });

    test('new offer starts now', () {
      final before = DateTime.now();
      final window = OfferSchedule.windowForSave(
        durationDays: 7,
        active: true,
        existing: null,
      );
      expect(
        window.startsAt.isAfter(before.subtract(const Duration(seconds: 2))),
        isTrue,
      );
      expect(window.endsAt.difference(window.startsAt).inDays, 7);
    });

    test('expired offer renews from now when saved again', () {
      final existing = Offer(
        id: 'o1',
        businessId: 'b1',
        title: 'Test',
        active: true,
        durationDays: 5,
        startsAt: DateTime.now().subtract(const Duration(days: 10)),
        endsAt: DateTime.now().subtract(const Duration(days: 3)),
        items: const [],
        productIds: const [],
      );
      final window = OfferSchedule.windowForSave(
        durationDays: 5,
        active: true,
        existing: existing,
      );
      expect(
        window.startsAt.isBefore(DateTime.now().add(const Duration(seconds: 2))),
        isTrue,
      );
    });
  });
}
