import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/internal_slug.dart';
import '../../../../core/utils/slug.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/employment_type.dart';
import '../../domain/entities/job_opening.dart';
import '../employment_type_labels.dart';

Future<void> showAddJobOpeningSheet(BuildContext context, WidgetRef ref) =>
    showJobOpeningSheet(context, ref);

Future<void> showJobOpeningSheet(
  BuildContext context,
  WidgetRef ref, {
  JobOpening? opening,
}) async {
  final providers = ProviderScope.containerOf(context, listen: false);
  final l10n = context.l10n;
  final isEdit = opening != null;

  final titleController = TextEditingController(text: opening?.title ?? '');
  final locationController = TextEditingController(text: opening?.location ?? '');
  final descriptionController =
      TextEditingController(text: opening?.description ?? '');
  final requirementsController =
      TextEditingController(text: opening?.requirements ?? '');
  final salaryController = TextEditingController(text: opening?.salaryHint ?? '');
  final applyEmailController = TextEditingController(text: opening?.applyEmail ?? '');
  final applyUrlController = TextEditingController(text: opening?.applyUrl ?? '');
  var imageUrl = opening?.imageUrl ?? '';
  PlatformFile? imageFile;
  var durationDays = opening?.durationDays ?? 30;
  var active = opening?.active ?? true;
  var employmentType = opening?.employmentType;

  final ok = await showAppSideSheet<bool>(
    context: context,
    title: isEdit ? l10n.jobEditTitle : l10n.jobAddTitle,
    saveLabel: isEdit ? l10n.saveChanges : l10n.jobSave,
    child: StatefulBuilder(
      builder: (context, setState) {
        final colors = context.appColors;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: l10n.jobTitleLabel,
              controller: titleController,
              hint: l10n.jobTitleHint,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.jobLocationLabel,
              controller: locationController,
              hint: l10n.jobLocationHint,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<EmploymentType?>(
              value: employmentType,
              decoration: InputDecoration(
                labelText: l10n.jobEmploymentTypeLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.jobEmploymentUnset)),
                ...EmploymentType.values.map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(employmentTypeLabel(l10n, t)),
                  ),
                ),
              ],
              onChanged: (v) => setState(() => employmentType = v),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.jobDescriptionLabel,
              controller: descriptionController,
              hint: l10n.jobDescriptionHint,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.jobRequirementsLabel,
              controller: requirementsController,
              hint: l10n.jobRequirementsHint,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.jobSalaryLabel,
              controller: salaryController,
              hint: l10n.jobSalaryHint,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.jobApplyEmailLabel,
              controller: applyEmailController,
              hint: l10n.jobApplyEmailHint,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.jobApplyUrlLabel,
              controller: applyUrlController,
              hint: l10n.jobApplyUrlHint,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.jobImageLabel,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  withData: true,
                );
                if (result == null || result.files.isEmpty) return;
                setState(() => imageFile = result.files.first);
              },
              icon: const Icon(Icons.image_outlined, size: 20),
              label: Text(imageFile != null ? imageFile!.name : l10n.jobPickImage),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.jobSectionDuration,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.jobDurationLabel(durationDays),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: durationDays.toDouble(),
              min: 1,
              max: 90,
              divisions: 89,
              label: '$durationDays',
              onChanged: (v) => setState(() => durationDays = v.round()),
            ),
            if (isEdit && opening.isExpired)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l10n.jobRenewHint,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colors.textMuted,
                    height: 1.35,
                  ),
                ),
              ),
            AppSwitchRow(
              label: l10n.jobActive,
              value: active,
              onChanged: (v) => setState(() => active = v),
            ),
          ],
        );
      },
    ),
    onSave: () => _saveJobOpening(
      context: context,
      providers: providers,
      opening: opening,
      isEdit: isEdit,
      titleController: titleController,
      locationController: locationController,
      descriptionController: descriptionController,
      requirementsController: requirementsController,
      salaryController: salaryController,
      applyEmailController: applyEmailController,
      applyUrlController: applyUrlController,
      imageUrl: imageUrl,
      imageFile: imageFile,
      durationDays: durationDays,
      active: active,
      employmentType: employmentType,
    ),
  );

  titleController.dispose();
  locationController.dispose();
  descriptionController.dispose();
  requirementsController.dispose();
  salaryController.dispose();
  applyEmailController.dispose();
  applyUrlController.dispose();

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEdit ? l10n.jobUpdated : l10n.jobSaved)),
    );
  }
}

Future<bool> _saveJobOpening({
  required BuildContext context,
  required ProviderContainer providers,
  required JobOpening? opening,
  required bool isEdit,
  required TextEditingController titleController,
  required TextEditingController locationController,
  required TextEditingController descriptionController,
  required TextEditingController requirementsController,
  required TextEditingController salaryController,
  required TextEditingController applyEmailController,
  required TextEditingController applyUrlController,
  required String imageUrl,
  required PlatformFile? imageFile,
  required int durationDays,
  required bool active,
  required EmploymentType? employmentType,
}) async {
  final l10n = context.l10n;
  final title = titleController.text.trim();
  if (title.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tableName), backgroundColor: Colors.red),
      );
    }
    return false;
  }

  final businessId = providers.read(currentBusinessIdProvider);
  if (businessId == null) return false;

  final repo = providers.read(jobOpeningRepositoryProvider);
  var resolvedImageUrl = imageUrl.trim();

  if (imageFile != null) {
    try {
      var url = await providers.read(mediaUploadServiceProvider).uploadSiteAsset(
            businessId: businessId,
            file: imageFile,
          );
      if (url.contains('firebasestorage')) {
        url = await providers
            .read(mediaUploadServiceProvider)
            .resolveImageUrl(url);
      }
      resolvedImageUrl = url;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  final slug = normalizeInternalSlug(isEdit ? opening!.slug : slugify(title));
  if (slug.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.internalSlugTaken), backgroundColor: Colors.red),
      );
    }
    return false;
  }

  if (await repo.isSlugTaken(
    businessId: businessId,
    slug: slug,
    excludeJobOpeningId: opening?.id,
  )) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.internalSlugTaken), backgroundColor: Colors.red),
      );
    }
    return false;
  }

  try {
    final days = durationDays.clamp(1, 90);
    final loc = locationController.text.trim();
    final desc = descriptionController.text.trim();
    final req = requirementsController.text.trim();
    final sal = salaryController.text.trim();
    final email = applyEmailController.text.trim();
    final url = applyUrlController.text.trim();

    if (isEdit && opening != null) {
      await repo.update(
        businessId: businessId,
        previous: opening,
        opening: JobOpening(
          id: opening.id,
          businessId: businessId,
          title: title,
          slug: opening.slug,
          titleI18n: opening.titleI18n,
          description: desc.isEmpty ? null : desc,
          descriptionI18n: opening.descriptionI18n,
          requirements: req.isEmpty ? null : req,
          requirementsI18n: opening.requirementsI18n,
          location: loc.isEmpty ? null : loc,
          employmentType: employmentType,
          salaryHint: sal.isEmpty ? null : sal,
          applyEmail: email.isEmpty ? null : email,
          applyUrl: url.isEmpty ? null : url,
          imageUrl: resolvedImageUrl.isEmpty ? null : resolvedImageUrl,
          durationDays: days,
          startsAt: opening.startsAt,
          endsAt: opening.endsAt,
          active: active,
          applicationCount: opening.applicationCount,
        ),
      );
    } else {
      await repo.create(
        businessId: businessId,
        title: title,
        slug: slug,
        description: desc.isEmpty ? null : desc,
        requirements: req.isEmpty ? null : req,
        location: loc.isEmpty ? null : loc,
        employmentType: employmentType,
        salaryHint: sal.isEmpty ? null : sal,
        applyEmail: email.isEmpty ? null : email,
        applyUrl: url.isEmpty ? null : url,
        imageUrl: resolvedImageUrl.isEmpty ? null : resolvedImageUrl,
        durationDays: days,
        active: active,
      );
    }
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authErrorMessage(e)),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }
}

Future<void> deleteJobOpening(
  BuildContext context,
  WidgetRef ref,
  JobOpening opening,
) async {
  final l10n = context.l10n;
  final ok = await showConfirmDeleteDialog(
    context,
    title: l10n.jobDeleteTitle,
    message: l10n.jobDeleteMessage(opening.title),
  );
  if (!ok || !context.mounted) return;

  final providers = ProviderScope.containerOf(context, listen: false);
  final businessId = providers.read(currentBusinessIdProvider);
  if (businessId == null) return;

  try {
    await providers.read(jobOpeningRepositoryProvider).delete(
          businessId: businessId,
          jobOpeningId: opening.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.jobDeleted)),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
      );
    }
  }
}
