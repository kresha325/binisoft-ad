import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../domain/entities/offer.dart';
import '../models/offer_model.dart';
import '../offer_schedule.dart';

class OfferRepository {
  OfferRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  Stream<List<Offer>> watchList({
    required String businessId,
    String displayLocale = 'sq',
  }) {
    return _paths.offers(businessId).snapshots().map((snap) {
      final offers = snap.docs
          .map(
            (d) => OfferModel.fromFirestore(d, displayLocale: displayLocale)
                .toEntity(),
          )
          .toList();
      offers.sort((a, b) => b.startsAt.compareTo(a.startsAt));
      return offers;
    });
  }

  Future<Offer> create({
    required String businessId,
    required String title,
    Map<String, String> titleI18n = const {},
    String? description,
    Map<String, String> descriptionI18n = const {},
    required List<OfferItem> items,
    required int durationDays,
    double? discountPercent,
    bool active = true,
  }) async {
    final ref = _paths.offers(businessId).doc();
    final window = OfferSchedule.windowForSave(
      durationDays: durationDays,
      active: active,
    );
    final productIds = items.map((i) => i.productId).toList();
    final days = OfferSchedule.clampDays(durationDays);

    final model = OfferModel(
      id: ref.id,
      businessId: businessId,
      title: title,
      titleI18n: titleI18n,
      description: description,
      descriptionI18n: descriptionI18n,
      items: items,
      productIds: productIds,
      durationDays: days,
      startsAt: window.startsAt,
      endsAt: window.endsAt,
      discountPercent: discountPercent,
      active: active,
    );

    await ref.set({
      ...model.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return model.toEntity();
  }

  Future<void> update({
    required String businessId,
    required Offer offer,
    Offer? previous,
  }) async {
    final window = OfferSchedule.windowForSave(
      durationDays: offer.durationDays,
      active: offer.active,
      existing: previous ?? offer,
    );
    final days = OfferSchedule.clampDays(offer.durationDays);

    final model = OfferModel(
      id: offer.id,
      businessId: businessId,
      title: offer.title,
      titleI18n: offer.titleI18n,
      description: offer.description,
      descriptionI18n: offer.descriptionI18n,
      items: offer.items,
      productIds: offer.productIds,
      durationDays: days,
      startsAt: window.startsAt,
      endsAt: window.endsAt,
      discountPercent: offer.discountPercent,
      active: offer.active,
    );
    await _paths.offers(businessId).doc(offer.id).update(model.toMap());
  }

  Future<void> delete({
    required String businessId,
    required String offerId,
  }) async {
    await _paths.offers(businessId).doc(offerId).delete();
  }
}
