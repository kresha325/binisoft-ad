import '../../../l10n/app_localizations.dart';
import '../domain/entities/employment_type.dart';

String employmentTypeLabel(AppLocalizations l10n, EmploymentType? type) {
  if (type == null) return '';
  return switch (type) {
    EmploymentType.fullTime => l10n.jobEmploymentFullTime,
    EmploymentType.partTime => l10n.jobEmploymentPartTime,
    EmploymentType.contract => l10n.jobEmploymentContract,
    EmploymentType.internship => l10n.jobEmploymentInternship,
    EmploymentType.temporary => l10n.jobEmploymentTemporary,
    EmploymentType.other => l10n.jobEmploymentOther,
  };
}
