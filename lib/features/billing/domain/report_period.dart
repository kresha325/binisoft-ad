enum ReportPeriod {
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  yearly('yearly');

  const ReportPeriod(this.value);
  final String value;

  static ReportPeriod fromString(String raw) {
    return ReportPeriod.values.firstWhere(
      (p) => p.value == raw,
      orElse: () => ReportPeriod.daily,
    );
  }

  String get labelSq => switch (this) {
        ReportPeriod.daily => 'Ditor',
        ReportPeriod.weekly => 'Javor',
        ReportPeriod.monthly => 'Mujor',
        ReportPeriod.yearly => 'Vjetor',
      };

  String get labelEn => switch (this) {
        ReportPeriod.daily => 'Daily',
        ReportPeriod.weekly => 'Weekly',
        ReportPeriod.monthly => 'Monthly',
        ReportPeriod.yearly => 'Yearly',
      };
}
