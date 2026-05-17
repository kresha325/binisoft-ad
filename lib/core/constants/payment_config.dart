/// Payment integration settings (Stripe / PayPal can be wired later).
abstract final class PaymentConfig {
  /// When true, confirming payment creates the account without charging.
  static const bool demoMode = true;

  static const String currencyCode = 'EUR';
  static const String currencySymbol = '€';
}
