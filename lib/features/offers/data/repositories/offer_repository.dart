import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../../../core/utils/slug.dart';
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

  Future<bool> isSlugTaken({
    required String businessId,
    required String slug,
    String? excludeOfferId,
  }) async {
    final normalized = slugify(slug);
    if (normalized.isEmpty) return false;
    final snap = await _paths
        .offers(businessId)
        .where('slug', isEqualTo: normalized)
        .limit(5)
        .get();
    for (final doc in snap.docs) {
      if (excludeOfferId != null && doc.id == excludeOfferId) continue;
      return true;
    }
    return false;
  }

  Future<Offer> create({
    required String businessId,
    required String title,
    required String slug,
    Map<String, String> titleI18n = const {},
    String? description,
    Map<String, String> descriptionI18n = const {},
    String? seoTitle,
    String? seoDescription,
    Map<String, String> seoTitleI18n = const {},
    Map<String, String> seoDescriptionI18n = const {},
    Map<String, String> localizedSlugs = const {},
    required List<OfferItem> items,
    required int durationDays,
    double? discountPercent,
    bool active = true,
  }) async {
    final internalSlug = slugify(slug);
    if (internalSlug.isEmpty) {
      throw Exception('Internal slug is required.');
    }
    if (await isSlugTaken(businessId: businessId, slug: internalSlug)) {
      throw Exception('This internal slug is already used by another offer.');
    }

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
      slug: internalSlug,
      titleI18n: titleI18n,
      description: description,
      descriptionI18n: descriptionI18n,
      seoTitle: seoTitle,
      seoDescription: seoDescription,
      seoTitleI18n: seoTitleI18n,
      seoDescriptionI18n: seoDescriptionI18n,
      localizedSlugs: localizedSlugs,
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
      slug: offer.slug,
      titleI18n: offer.titleI18n,
      description: offer.description,
      descriptionI18n: offer.descriptionI18n,
      seoTitle: offer.seoTitle,
      seoDescription: offer.seoDescription,
      seoTitleI18n: offer.seoTitleI18n,
      seoDescriptionI18n: offer.seoDescriptionI18n,
      localizedSlugs: offer.localizedSlugs,
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
