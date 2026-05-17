enum InvoiceType {
  subscription('subscription'),
  monthly('monthly');

  const InvoiceType(this.value);
  final String value;

  static InvoiceType fromString(String raw) {
    return InvoiceType.values.firstWhere(
      (t) => t.value == raw,
      orElse: () => InvoiceType.subscription,
    );
  }

  String get label => switch (this) {
        InvoiceType.subscription => 'Subscription',
        InvoiceType.monthly => 'Monthly payment',
      };

  String get labelSq => switch (this) {
        InvoiceType.subscription => 'Abonim',
        InvoiceType.monthly => 'Pagesë mujore',
      };
}
