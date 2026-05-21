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
import '../../domain/entities/contest.dart';

Future<void> showAddContestSheet(BuildContext context, WidgetRef ref) =>
    showContestSheet(context, ref);

Future<void> showContestSheet(
  BuildContext context,
  WidgetRef ref, {
  Contest? contest,
}) async {
  final providers = ProviderScope.containerOf(context, listen: false);
  final l10n = context.l10n;
  final isEdit = contest != null;

  final titleController = TextEditingController(text: contest?.title ?? '');
  final prizeController = TextEditingController(text: contest?.prize ?? '');
  final descriptionController =
      TextEditingController(text: contest?.description ?? '');
  final rulesController = TextEditingController(text: contest?.rules ?? '');
  var imageUrl = contest?.imageUrl ?? '';
  PlatformFile? imageFile;
  var durationDays = contest?.durationDays ?? 14;
  var active = contest?.active ?? true;

  final ok = await showAppSideSheet<bool>(
    context: context,
    title: isEdit ? l10n.contestEditTitle : l10n.contestAddTitle,
    saveLabel: isEdit ? l10n.saveChanges : l10n.contestSave,
    child: StatefulBuilder(
      builder: (context, setState) {
        final colors = context.appColors;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: l10n.contestTitleLabel,
              controller: titleController,
              hint: l10n.contestTitleHint,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.contestPrizeLabel,
              controller: prizeController,
              hint: l10n.contestPrizeHint,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.contestDescriptionLabel,
              controller: descriptionController,
              hint: l10n.contestDescriptionHint,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.contestRulesLabel,
              controller: rulesController,
              hint: l10n.contestRulesHint,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.contestImageLabel,
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
                setState(() {
                  imageFile = result.files.first;
                });
              },
              icon: const Icon(Icons.image_outlined, size: 20),
              label: Text(
                imageFile != null
                    ? imageFile!.name
                    : l10n.contestPickImage,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.contestSectionDuration,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.contestDurationLabel(durationDays),
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
            if (isEdit && contest.isExpired)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l10n.contestRenewHint,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colors.textMuted,
                    height: 1.35,
                  ),
                ),
              ),
            AppSwitchRow(
              label: l10n.contestActive,
              value: active,
              onChanged: (v) => setState(() => active = v),
            ),
          ],
        );
      },
    ),
    onSave: () => _saveContest(
      context: context,
      providers: providers,
      contest: contest,
      isEdit: isEdit,
      titleController: titleController,
      prizeController: prizeController,
      descriptionController: descriptionController,
      rulesController: rulesController,
      imageUrl: imageUrl,
      imageFile: imageFile,
      durationDays: durationDays,
      active: active,
    ),
  );

  titleController.dispose();
  prizeController.dispose();
  descriptionController.dispose();
  rulesController.dispose();

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEdit ? l10n.contestUpdated : l10n.contestSaved)),
    );
  }
}

Future<bool> _saveContest({
  required BuildContext context,
  required ProviderContainer providers,
  required Contest? contest,
  required bool isEdit,
  required TextEditingController titleController,
  required TextEditingController prizeController,
  required TextEditingController descriptionController,
  required TextEditingController rulesController,
  required String imageUrl,
  required PlatformFile? imageFile,
  required int durationDays,
  required bool active,
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

  final repo = providers.read(contestRepositoryProvider);
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

  final slug = normalizeInternalSlug(
    isEdit ? contest!.slug : slugify(title),
  );
  if (slug.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.internalSlugTaken),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }

  if (await repo.isSlugTaken(
    businessId: businessId,
    slug: slug,
    excludeContestId: contest?.id,
  )) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.internalSlugTaken),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }

  try {
    final days = durationDays.clamp(1, 90);
    if (isEdit && contest != null) {
      await repo.update(
        businessId: businessId,
        previous: contest,
        contest: Contest(
          id: contest.id,
          businessId: businessId,
          title: title,
          slug: contest.slug,
          titleI18n: contest.titleI18n,
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
          descriptionI18n: contest.descriptionI18n,
          prize: prizeController.text.trim().isEmpty
              ? null
              : prizeController.text.trim(),
          prizeI18n: contest.prizeI18n,
          rules: rulesController.text.trim().isEmpty
              ? null
              : rulesController.text.trim(),
          rulesI18n: contest.rulesI18n,
          imageUrl: resolvedImageUrl.isEmpty ? null : resolvedImageUrl,
          durationDays: days,
          startsAt: contest.startsAt,
          endsAt: contest.endsAt,
          active: active,
          entryCount: contest.entryCount,
        ),
      );
    } else {
      await repo.create(
        businessId: businessId,
        title: title,
        slug: slug,
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        prize: prizeController.text.trim().isEmpty
            ? null
            : prizeController.text.trim(),
        rules: rulesController.text.trim().isEmpty
            ? null
            : rulesController.text.trim(),
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

Future<void> deleteContest(
  BuildContext context,
  WidgetRef ref,
  Contest contest,
) async {
  final l10n = context.l10n;
  final ok = await showConfirmDeleteDialog(
    context,
    title: l10n.contestDeleteTitle,
    message: l10n.contestDeleteMessage(contest.title),
  );
  if (!ok || !context.mounted) return;

  final providers = ProviderScope.containerOf(context, listen: false);
  final businessId = providers.read(currentBusinessIdProvider);
  if (businessId == null) return;

  try {
    await providers.read(contestRepositoryProvider).delete(
          businessId: businessId,
          contestId: contest.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.contestDeleted)),
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
