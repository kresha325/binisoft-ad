import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/localized_text.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/slug.dart';
import '../../../../core/widgets/app_form_dialog.dart';
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
  var nameValues = LocalizedText.initialValues(
    defaultLocale: locales.defaultLocale,
    enabledLocales: locales.enabledLocales,
    i18n: category?.nameI18n,
    primary: category?.name,
  );
  var descValues = LocalizedText.initialValues(
    defaultLocale: locales.defaultLocale,
    enabledLocales: locales.enabledLocales,
    i18n: category?.descriptionI18n,
    primary: category?.description,
  );

  final ok = await showAppFormDialog<bool>(
    context: context,
    title: isEdit ? 'Edit Category' : 'Add Category',
    saveLabel: isEdit ? 'Save Changes' : 'Save Category',
    child: Consumer(
      builder: (context, ref, _) {
        final localeConfig = ref.watch(businessLocalesProvider);
        return StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LocalizedFieldsEditor(
                label: 'Name',
                enabledLocales: localeConfig.enabledLocales,
                values: nameValues,
                onChanged: (v) => setState(() => nameValues = v),
              ),
              LocalizedFieldsEditor(
                label: 'Description',
                enabledLocales: localeConfig.enabledLocales,
                values: descValues,
                multiline: true,
                onChanged: (v) => setState(() => descValues = v),
              ),
            ],
          ),
        );
      },
    ),
    onSave: () async {
      final localeConfig = ref.read(businessLocalesProvider);
      final nameError = validateLocalizedRequired(
        values: nameValues,
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

      final businessId = ref.read(currentBusinessIdProvider);
      if (businessId == null) return false;

      final packedName = LocalizedText.packForSave(
        defaultLocale: localeConfig.defaultLocale,
        enabledLocales: localeConfig.enabledLocales,
        values: nameValues,
      );
      final packedDesc = LocalizedText.packForSave(
        defaultLocale: localeConfig.defaultLocale,
        enabledLocales: localeConfig.enabledLocales,
        values: descValues,
      );
      final name = packedName.primary;
      final description =
          packedDesc.primary.isEmpty ? null : packedDesc.primary;

      try {
        final editing = category;
        if (isEdit && editing != null) {
          await ref.read(categoryRepositoryProvider).update(
                businessId: businessId,
                category: Category(
                  id: editing.id,
                  businessId: businessId,
                  name: name,
                  slug: slugify(name),
                  order: editing.order,
                  parentId: editing.parentId,
                  description: description,
                  nameI18n: packedName.i18n,
                  descriptionI18n: packedDesc.i18n,
                ),
              );
        } else {
          final existing =
              await ref.read(categoryRepositoryProvider).list(businessId: businessId);
          await ref.read(categoryRepositoryProvider).create(
                businessId: businessId,
                name: name,
                description: description,
                order: existing.length,
                nameI18n: packedName.i18n,
                descriptionI18n: packedDesc.i18n,
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
