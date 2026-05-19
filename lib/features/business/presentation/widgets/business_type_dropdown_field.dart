import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/business_type.dart';

/// Dropdown for [BusinessType] with long labels (avoids horizontal overflow).
class BusinessTypeDropdownField extends StatelessWidget {
  const BusinessTypeDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labelText,
    this.hint,
  });

  final BusinessType? value;
  final ValueChanged<BusinessType?>? onChanged;
  final String labelText;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DropdownButtonFormField<BusinessType>(
      isExpanded: true,
      value: value,
      decoration: InputDecoration(labelText: labelText),
      hint: hint != null
          ? Text(hint!, overflow: TextOverflow.ellipsis, maxLines: 1)
          : null,
      menuMaxHeight: 360,
      items: [
        for (final type in BusinessType.choices)
          DropdownMenuItem(
            value: type,
            child: Text(
              type.label(l10n),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
      ],
      selectedItemBuilder: (context) => [
        for (final type in BusinessType.choices)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              type.label(l10n),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
