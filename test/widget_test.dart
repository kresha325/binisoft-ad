import 'package:flutter_test/flutter_test.dart';

import 'package:business_dashboard/features/offers/data/offer_schedule.dart';

void main() {
  test('OfferSchedule clampDays is stable', () {
    expect(OfferSchedule.clampDays(15), 15);
  });
}
