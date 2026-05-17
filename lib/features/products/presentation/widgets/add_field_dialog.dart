import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/localized_text.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/slug.dart';
import '../../../../core/widgets/app_form_dialog.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_input_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/localized_fields_editor.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/attribute_type_labels.dart';
import '../../domain/entities/attribute_definition.dart';

Future<void> showAddFieldDialog(BuildContext context, WidgetRef ref) async {
  final locales = ref.read(businessLocalesProvider);
  var labelValues = LocalizedText.initialValues(
    defaultLocale: locales.defaultLocale,
    enabledLocales: locales.enabledLocales,
  );
  final keyController = TextEditingController();
  var type = AttributeType.text;
  var required = false;
  var active = true;
  var keyManual = false;

  final ok = await showAppFormDialog<bool>(
    context: context,
    title: 'Add Field',
    saveLabel: 'Save Field',
    child: Consumer(
      builder: (context, ref, _) {
        final localeConfig = ref.watch(businessLocalesProvider);
        return StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LocalizedFieldsEditor(
                label: 'Label',
                enabledLocales: localeConfig.enabledLocales,
                values: labelValues,
                onChanged: (v) {
                  setState(() {
                    labelValues = v;
                    if (!keyManual) {
                      keyController.text = slugify(
                        v[localeConfig.defaultLocale] ?? '',
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Key (Name)',
                controller: keyController,
                hint: 'color',
                onChanged: (_) => keyManual = true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: type.label,
                dropdownColor: context.appColors.surface,
                style: AppInputStyles.fieldText(context),
                decoration: AppInputStyles.dropdownDecoration(context, labelText: 'Type'),
                items: AttributeType.values
                    .map(
                      (t) => DropdownMenuItem(
                        value: t.label,
                        child: Text(t.label, style: AppInputStyles.fieldText(context)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(
                  () => type = AttributeTypeLabels.fromLabel(v ?? type.label),
                ),
              ),
              const SizedBox(height: 8),
              AppSwitchRow(
                label: 'Required',
                value: required,
                onChanged: (v) => setState(() => required = v),
              ),
              AppSwitchRow(
                label: 'Active',
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
      final labelError = validateLocalizedRequired(
        values: labelValues,
        defaultLocale: localeConfig.defaultLocale,
        fieldLabel: 'Label',
      );
      if (labelError != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(labelError), backgroundColor: Colors.red),
          );
        }
        return false;
      }

      final businessId = ref.read(currentBusinessIdProvider);
      if (businessId == null) return false;

      final packed = LocalizedText.packForSave(
        defaultLocale: localeConfig.defaultLocale,
        enabledLocales: localeConfig.enabledLocales,
        values: labelValues,
      );

      try {
        await ref.read(attributeRepositoryProvider).create(
              businessId: businessId,
              name: packed.primary,
              nameI18n: packed.i18n,
              key: slugify(keyController.text.trim()),
              type: type,
              required: required,
              active: active,
            );
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
      const SnackBar(content: Text('Field created')),
    );
  }
}
