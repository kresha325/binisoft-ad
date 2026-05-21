import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../../../core/utils/slug.dart';
import '../../domain/entities/employment_type.dart';
import '../../domain/entities/job_opening.dart';
import '../../domain/entities/job_application.dart';
import '../../../contests/data/contest_schedule.dart';
import '../../../contests/domain/entities/contest.dart';
import '../models/job_application_model.dart';
import '../models/job_opening_model.dart';

class JobOpeningRepository {
  JobOpeningRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  CollectionReference<Map<String, dynamic>> _openings(String businessId) =>
      _paths.jobOpenings(businessId);

  CollectionReference<Map<String, dynamic>> _applications(
    String businessId,
    String jobOpeningId,
  ) =>
      _openings(businessId).doc(jobOpeningId).collection('applications');

  Stream<List<JobOpening>> watchList({
    required String businessId,
    String displayLocale = 'sq',
  }) {
    return _openings(businessId).orderBy('startsAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map(
                (d) => JobOpeningModel.fromFirestore(d, displayLocale: displayLocale)
                    .toEntity(),
              )
              .toList(),
        );
  }

  Stream<List<JobApplication>> watchApplications({
    required String businessId,
    required String jobOpeningId,
  }) {
    return _applications(businessId, jobOpeningId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => JobApplicationModel.fromFirestore(d).toEntity()).toList(),
        );
  }

  Future<bool> isSlugTaken({
    required String businessId,
    required String slug,
    String? excludeJobOpeningId,
  }) async {
    final normalized = slugify(slug);
    if (normalized.isEmpty) return false;
    final snap = await _openings(businessId)
        .where('slug', isEqualTo: normalized)
        .limit(5)
        .get();
    for (final doc in snap.docs) {
      if (excludeJobOpeningId != null && doc.id == excludeJobOpeningId) continue;
      return true;
    }
    return false;
  }

  Future<JobOpening> create({
    required String businessId,
    required String title,
    required String slug,
    String? description,
    String? requirements,
    String? location,
    EmploymentType? employmentType,
    String? salaryHint,
    String? applyEmail,
    String? applyUrl,
    String? imageUrl,
    required int durationDays,
    bool active = true,
  }) async {
    final internalSlug = slugify(slug);
    if (internalSlug.isEmpty) {
      throw Exception('Internal slug is required.');
    }
    if (await isSlugTaken(businessId: businessId, slug: internalSlug)) {
      throw Exception('This internal slug is already used by another job opening.');
    }

    final ref = _openings(businessId).doc();
    final window = ContestSchedule.windowForSave(
      durationDays: durationDays,
      active: active,
    );
    final days = ContestSchedule.clampDays(durationDays);

    final model = JobOpeningModel(
      id: ref.id,
      businessId: businessId,
      title: title,
      slug: internalSlug,
      description: description,
      requirements: requirements,
      location: location,
      employmentType: employmentType,
      salaryHint: salaryHint,
      applyEmail: applyEmail,
      applyUrl: applyUrl,
      imageUrl: imageUrl,
      durationDays: days,
      startsAt: window.startsAt,
      endsAt: window.endsAt,
      active: active,
      applicationCount: 0,
    );

    await ref.set({
      ...model.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return model.toEntity();
  }

  Future<void> update({
    required String businessId,
    required JobOpening opening,
    JobOpening? previous,
  }) async {
    Contest? scheduleExisting;
    final base = previous ?? opening;
    scheduleExisting = Contest(
      id: base.id,
      businessId: base.businessId,
      title: base.title,
      slug: base.slug,
      durationDays: base.durationDays,
      startsAt: base.startsAt,
      endsAt: base.endsAt,
      active: base.active,
    );
    final window = ContestSchedule.windowForSave(
      durationDays: opening.durationDays,
      active: opening.active,
      existing: scheduleExisting,
    );
    final days = ContestSchedule.clampDays(opening.durationDays);

    final model = JobOpeningModel(
      id: opening.id,
      businessId: businessId,
      title: opening.title,
      slug: opening.slug,
      titleI18n: opening.titleI18n,
      description: opening.description,
      descriptionI18n: opening.descriptionI18n,
      requirements: opening.requirements,
      requirementsI18n: opening.requirementsI18n,
      location: opening.location,
      employmentType: opening.employmentType,
      salaryHint: opening.salaryHint,
      applyEmail: opening.applyEmail,
      applyUrl: opening.applyUrl,
      imageUrl: opening.imageUrl,
      durationDays: days,
      startsAt: window.startsAt,
      endsAt: window.endsAt,
      active: opening.active,
      applicationCount: opening.applicationCount,
    );
    await _openings(businessId).doc(opening.id).update(model.toMap());
  }

  Future<void> delete({
    required String businessId,
    required String jobOpeningId,
  }) async {
    final apps = await _applications(businessId, jobOpeningId).get();
    final batch = _openings(businessId).firestore.batch();
    for (final doc in apps.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_openings(businessId).doc(jobOpeningId));
    await batch.commit();
  }
}
