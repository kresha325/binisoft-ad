import 'package:business_dashboard/l10n/app_localizations.dart';

import '../../features/products/domain/entities/attribute_definition.dart';

extension AttributeTypeL10n on AttributeType {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        AttributeType.text => l10n.attrTypeText,
        AttributeType.textarea => l10n.attrTypeTextarea,
        AttributeType.number => l10n.attrTypeNumber,
        AttributeType.select => l10n.attrTypeSelect,
        AttributeType.multiSelect => l10n.attrTypeMultiSelect,
        AttributeType.color => l10n.attrTypeColor,
        AttributeType.boolean => l10n.attrTypeBoolean,
      };
}
