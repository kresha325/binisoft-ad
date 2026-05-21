import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../../../core/utils/slug.dart';
import '../../domain/entities/contest.dart';
import '../../domain/entities/contest_entry.dart';
import '../contest_schedule.dart';
import '../models/contest_entry_model.dart';
import '../models/contest_model.dart';

class ContestRepository {
  ContestRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  CollectionReference<Map<String, dynamic>> _contests(String businessId) =>
      _paths.contests(businessId);

  CollectionReference<Map<String, dynamic>> _entries(
    String businessId,
    String contestId,
  ) =>
      _contests(businessId).doc(contestId).collection('entries');

  Stream<List<Contest>> watchList({
    required String businessId,
    String displayLocale = 'sq',
  }) {
    return _contests(businessId).orderBy('startsAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map(
                (d) => ContestModel.fromFirestore(d, displayLocale: displayLocale)
                    .toEntity(),
              )
              .toList(),
        );
  }

  Stream<List<ContestEntry>> watchEntries({
    required String businessId,
    required String contestId,
  }) {
    return _entries(businessId, contestId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => ContestEntryModel.fromFirestore(d).toEntity()).toList(),
        );
  }

  Future<bool> isSlugTaken({
    required String businessId,
    required String slug,
    String? excludeContestId,
  }) async {
    final normalized = slugify(slug);
    if (normalized.isEmpty) return false;
    final snap = await _contests(businessId)
        .where('slug', isEqualTo: normalized)
        .limit(5)
        .get();
    for (final doc in snap.docs) {
      if (excludeContestId != null && doc.id == excludeContestId) continue;
      return true;
    }
    return false;
  }

  Future<Contest> create({
    required String businessId,
    required String title,
    required String slug,
    String? description,
    String? prize,
    String? rules,
    String? imageUrl,
    required int durationDays,
    bool active = true,
  }) async {
    final internalSlug = slugify(slug);
    if (internalSlug.isEmpty) {
      throw Exception('Internal slug is required.');
    }
    if (await isSlugTaken(businessId: businessId, slug: internalSlug)) {
      throw Exception('This internal slug is already used by another contest.');
    }

    final ref = _contests(businessId).doc();
    final window = ContestSchedule.windowForSave(
      durationDays: durationDays,
      active: active,
    );
    final days = ContestSchedule.clampDays(durationDays);

    final model = ContestModel(
      id: ref.id,
      businessId: businessId,
      title: title,
      slug: internalSlug,
      description: description,
      prize: prize,
      rules: rules,
      imageUrl: imageUrl,
      durationDays: days,
      startsAt: window.startsAt,
      endsAt: window.endsAt,
      active: active,
      entryCount: 0,
    );

    await ref.set({
      ...model.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return model.toEntity();
  }

  Future<void> update({
    required String businessId,
    required Contest contest,
    Contest? previous,
  }) async {
    final window = ContestSchedule.windowForSave(
      durationDays: contest.durationDays,
      active: contest.active,
      existing: previous ?? contest,
    );
    final days = ContestSchedule.clampDays(contest.durationDays);

    final model = ContestModel(
      id: contest.id,
      businessId: businessId,
      title: contest.title,
      slug: contest.slug,
      titleI18n: contest.titleI18n,
      description: contest.description,
      descriptionI18n: contest.descriptionI18n,
      prize: contest.prize,
      prizeI18n: contest.prizeI18n,
      rules: contest.rules,
      rulesI18n: contest.rulesI18n,
      imageUrl: contest.imageUrl,
      durationDays: days,
      startsAt: window.startsAt,
      endsAt: window.endsAt,
      active: contest.active,
      entryCount: contest.entryCount,
    );
    await _contests(businessId).doc(contest.id).update(model.toMap());
  }

  Future<void> delete({
    required String businessId,
    required String contestId,
  }) async {
    final entries = await _entries(businessId, contestId).get();
    final batch = _contests(businessId).firestore.batch();
    for (final doc in entries.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_contests(businessId).doc(contestId));
    await batch.commit();
  }
}
