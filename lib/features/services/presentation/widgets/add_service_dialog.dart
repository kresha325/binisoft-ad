import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/catalog_localized_content.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/internal_slug.dart';
import '../../../../core/widgets/app_form_dialog.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../../../core/widgets/internal_slug_field.dart';
import '../../../../core/widgets/localized_catalog_content_editor.dart';
import '../../../../core/widgets/localized_fields_editor.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/entities/business_service.dart';

Future<void> showAddServiceDialog(BuildContext context, WidgetRef ref) =>
    showServiceDialog(context, ref);

Future<void> showServiceDialog(
  BuildContext context,
  WidgetRef ref, {
  BusinessService? service,
}) async {
  final isEdit = service != null;
  final locales = ref.read(businessLocalesProvider);
  final l10n = context.l10n;
  var content = CatalogLocalizedContent.initial(
    defaultLocale: locales.defaultLocale,
    enabledLocales: locales.enabledLocales,
    nameI18n: service?.nameI18n,
    descriptionI18n: service?.descriptionI18n,
    primaryName: service?.name,
    primaryDescription: service?.description,
  );

  final slugController = TextEditingController(text: service?.slug ?? '');
  final durationController = TextEditingController(
    text: service?.durationMinutes?.toString() ?? '',
  );
  final priceController = TextEditingController(
    text: service?.priceEur != null && service!.priceEur! > 0
        ? service.priceEur!.toStringAsFixed(2)
        : '',
  );
  var slugManual = isEdit;
  var active = service?.active ?? true;

  void maybeSuggestSlug(void Function(void Function()) setState) {
    if (isEdit || slugManual) return;
    final name = content.name[locales.defaultLocale]?.trim() ?? '';
    if (name.isEmpty) return;
    setState(() => slugController.text = normalizeInternalSlug(name));
  }

  final ok = await showAppFormDialog<bool>(
    context: context,
    title: isEdit ? l10n.serviceEditTitle : l10n.serviceAddTitle,
    saveLabel: isEdit ? l10n.saveChanges : l10n.serviceSave,
    child: Consumer(
      builder: (context, ref, _) {
        final localeConfig = ref.watch(businessLocalesProvider);
        final businessId = ref.watch(currentBusinessIdProvider);
        if (businessId == null) return const SizedBox.shrink();

        return StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InternalSlugField(
                controller: slugController,
                readOnly: isEdit,
                onManualEdit: () => slugManual = true,
              ),
              const SizedBox(height: 16),
              LocalizedCatalogContentEditor(
                businessId: businessId,
                defaultLocale: localeConfig.defaultLocale,
                enabledLocales: localeConfig.enabledLocales,
                content: content,
                nameLabel: l10n.serviceName,
                descriptionLabel: l10n.serviceDescription,
                onChanged: (next) {
                  setState(() {
                    content = next;
                    maybeSuggestSlug(setState);
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: l10n.serviceDurationMinutes,
                  hintText: l10n.serviceDurationHint,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: l10n.servicePriceEur),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              AppSwitchRow(
                label: l10n.serviceActive,
                value: active,
                onChanged: (v) => setState(() => active = v),
              ),
            ],
          ),
        );
      },
    ),
    onSave: () async {
      final localeConfig = ref.read(businessLocalesProvider);

      final nameError = validateLocalizedRequired(
        values: content.name,
        defaultLocale: localeConfig.defaultLocale,
        fieldLabel: l10n.serviceName,
      );
      if (nameError != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(nameError), backgroundColor: Colors.red),
          );
        }
        return false;
      }

      final slugError = validateInternalSlugField(slugController.text.trim());
      if (slugError != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(slugError), backgroundColor: Colors.red),
          );
        }
        return false;
      }

      final businessId = ref.read(currentBusinessIdProvider);
      if (businessId == null) return false;

      final internalSlug = normalizeInternalSlug(slugController.text.trim());
      final repo = ref.read(serviceRepositoryProvider);

      final taken = await repo.isSlugTaken(
        businessId: businessId,
        slug: internalSlug,
        excludeServiceId: service?.id,
      );
      if (taken) {
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

      final durationRaw = durationController.text.trim();
      final durationMinutes =
          durationRaw.isEmpty ? null : int.tryParse(durationRaw);
      final priceRaw = priceController.text.trim().replaceAll(',', '.');
      final priceEur = priceRaw.isEmpty ? null : double.tryParse(priceRaw);

      final packed = content.packForSave(
        defaultLocale: localeConfig.defaultLocale,
        enabledLocales: localeConfig.enabledLocales,
      );
      final name = packed.name.primary;
      final description =
          packed.description.primary.isEmpty ? null : packed.description.primary;

      try {
        final editing = service;
        if (isEdit && editing != null) {
          await repo.update(
            businessId: businessId,
            service: BusinessService(
              id: editing.id,
              businessId: businessId,
              name: name,
              slug: editing.slug,
              order: editing.order,
              description: description,
              durationMinutes: durationMinutes,
              priceEur: priceEur,
              active: active,
              nameI18n: packed.name.i18n,
              descriptionI18n: packed.description.i18n,
            ),
          );
        } else {
          final existing = await repo.list(businessId: businessId);
          await repo.create(
            businessId: businessId,
            name: name,
            slug: internalSlug,
            description: description,
            durationMinutes: durationMinutes,
            priceEur: priceEur,
            active: active,
            order: existing.length,
            nameI18n: packed.name.i18n,
            descriptionI18n: packed.description.i18n,
          );
        }
        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
          );
        }
        return false;
      }
    },
  );

  slugController.dispose();
  durationController.dispose();
  priceController.dispose();

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEdit ? l10n.serviceUpdated : l10n.serviceCreated),
      ),
    );
  }
}

Future<void> deleteService(
  BuildContext context,
  WidgetRef ref,
  BusinessService service,
) async {
  final businessId = ref.read(currentBusinessIdProvider);
  if (businessId == null) return;
  final l10n = context.l10n;

  try {
    await ref.read(serviceRepositoryProvider).delete(
          businessId: businessId,
          serviceId: service.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.serviceDeleted)),
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
