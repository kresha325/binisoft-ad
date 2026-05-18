import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/catalog_localized_content.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/internal_slug.dart';
import '../../../../core/widgets/app_form_dialog.dart';
import '../../../../core/widgets/internal_slug_field.dart';
import '../../../../core/widgets/localized_catalog_content_editor.dart';
import '../../../../core/widgets/localized_slugs_editor.dart';
import '../../../../core/widgets/localized_fields_editor.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/entities/category.dart';

Future<void> showAddCategoryDialog(BuildContext context, WidgetRef ref) =>
    showCategoryDialog(context, ref);

Future<void> showCategoryDialog(
  BuildContext context,
  WidgetRef ref, {
  Category? category,
}) async {
  final isEdit = category != null;
  final locales = ref.read(businessLocalesProvider);
  var content = CatalogLocalizedContent.initial(
    defaultLocale: locales.defaultLocale,
    enabledLocales: locales.enabledLocales,
    nameI18n: category?.nameI18n,
    descriptionI18n: category?.descriptionI18n,
    seoTitleI18n: category?.seoTitleI18n,
    seoDescriptionI18n: category?.seoDescriptionI18n,
    primaryName: category?.name,
    primaryDescription: category?.description,
    primarySeoTitle: category?.seoTitle,
    primarySeoDescription: category?.seoDescription,
  );

  final slugController = TextEditingController(text: category?.slug ?? '');
  var slugManual = isEdit;
  var localizedSlugs = Map<String, String>.from(category?.localizedSlugs ?? {});

  void maybeSuggestSlug(void Function(void Function()) setState) {
    if (isEdit || slugManual) return;
    final name = content.name[locales.defaultLocale]?.trim() ?? '';
    if (name.isEmpty) return;
    setState(() => slugController.text = normalizeInternalSlug(name));
  }

  final ok = await showAppFormDialog<bool>(
    context: context,
    title: isEdit ? 'Edit Category' : 'Add Category',
    saveLabel: isEdit ? 'Save Changes' : 'Save Category',
    child: Consumer(
      builder: (context, ref, _) {
        final localeConfig = ref.watch(businessLocalesProvider);
        final businessId = ref.watch(currentBusinessIdProvider);
        if (businessId == null) {
          return const SizedBox.shrink();
        }

        return StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InternalSlugField(
                controller: slugController,
                readOnly: isEdit,
                onManualEdit: () => slugManual = true,
              ),
              const SizedBox(height: 8),
              LocalizedSlugsEditor(
                internalSlug: normalizeInternalSlug(slugController.text),
                defaultLocale: localeConfig.defaultLocale,
                enabledLocales: localeConfig.enabledLocales,
                values: localizedSlugs,
                onChanged: (v) => setState(() => localizedSlugs = v),
              ),
              const SizedBox(height: 16),
              LocalizedCatalogContentEditor(
                businessId: businessId,
                defaultLocale: localeConfig.defaultLocale,
                enabledLocales: localeConfig.enabledLocales,
                content: content,
                nameLabel: 'Name',
                descriptionLabel: 'Description',
                onChanged: (next) {
                  setState(() {
                    content = next;
                    maybeSuggestSlug(setState);
                  });
                },
              ),
            ],
          ),
        );
      },
    ),
    onSave: () async {
      final localeConfig = ref.read(businessLocalesProvider);
      final l10n = context.l10n;

      final nameError = validateLocalizedRequired(
        values: content.name,
        defaultLocale: localeConfig.defaultLocale,
        fieldLabel: 'Name',
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
      final repo = ref.read(categoryRepositoryProvider);

      final taken = await repo.isSlugTaken(
        businessId: businessId,
        slug: internalSlug,
        excludeCategoryId: category?.id,
      );
      if (taken) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.internalSlugTaken), backgroundColor: Colors.red),
          );
        }
        return false;
      }

      final packed = content.packForSave(
        defaultLocale: localeConfig.defaultLocale,
        enabledLocales: localeConfig.enabledLocales,
      );
      final name = packed.name.primary;
      final description =
          packed.description.primary.isEmpty ? null : packed.description.primary;
      final seoTitle =
          packed.seoTitle.primary.isEmpty ? null : packed.seoTitle.primary;
      final seoDescription = packed.seoDescription.primary.isEmpty
          ? null
          : packed.seoDescription.primary;

      try {
        final editing = category;
        if (isEdit && editing != null) {
          await repo.update(
            businessId: businessId,
            category: Category(
              id: editing.id,
              businessId: businessId,
              name: name,
              slug: editing.slug,
              order: editing.order,
              parentId: editing.parentId,
              description: description,
              seoTitle: seoTitle,
              seoDescription: seoDescription,
              nameI18n: packed.name.i18n,
              descriptionI18n: packed.description.i18n,
              seoTitleI18n: packed.seoTitle.i18n,
              seoDescriptionI18n: packed.seoDescription.i18n,
              localizedSlugs: localizedSlugs,
            ),
          );
        } else {
          final existing = await repo.list(businessId: businessId);
          await repo.create(
            businessId: businessId,
            name: name,
            slug: internalSlug,
            description: description,
            seoTitle: seoTitle,
            seoDescription: seoDescription,
            order: existing.length,
            nameI18n: packed.name.i18n,
            descriptionI18n: packed.description.i18n,
            seoTitleI18n: packed.seoTitle.i18n,
            seoDescriptionI18n: packed.seoDescription.i18n,
            localizedSlugs: localizedSlugs,
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

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEdit ? 'Category updated' : 'Category created')),
    );
  }
}

Future<void> deleteCategory(
  BuildContext context,
  WidgetRef ref,
  Category category,
) async {
  final businessId = ref.read(currentBusinessIdProvider);
  if (businessId == null) return;

  try {
    await ref.read(categoryRepositoryProvider).delete(
          businessId: businessId,
          categoryId: category.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted')),
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
