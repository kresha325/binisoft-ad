import 'package:business_dashboard/l10n/app_localizations.dart';

import '../constants/user_roles.dart';

extension UserRoleL10n on UserRole {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        UserRole.superadmin => l10n.roleSuperadmin,
        UserRole.owner => l10n.roleOwner,
        UserRole.admin => l10n.roleAdmin,
        UserRole.manager => l10n.roleManager,
        UserRole.employee => l10n.roleEmployee,
      };
}
