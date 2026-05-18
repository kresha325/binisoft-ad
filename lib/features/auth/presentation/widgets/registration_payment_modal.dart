import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/constants/payment_config.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_section_card.dart';

enum PaymentCheckoutKind { registration, newBusiness }

/// Checkout summary for registration or new business activation.
class SubscriptionCheckout {
  const SubscriptionCheckout({
    required this.plan,
    required this.amountDueToday,
    required this.monthlyAfter,
    required this.kind,
    this.businessName,
  });

  final BusinessPlan plan;
  final double amountDueToday;
  final double monthlyAfter;
  final PaymentCheckoutKind kind;
  final String? businessName;

  factory SubscriptionCheckout.registration(BusinessPlan plan) {
    return SubscriptionCheckout(
      plan: plan,
      amountDueToday: plan.registrationEuro,
      monthlyAfter: plan.monthlyEuro,
      kind: PaymentCheckoutKind.registration,
    );
  }

  factory SubscriptionCheckout.newBusiness({
    required BusinessPlan plan,
    required String businessName,
  }) {
    return SubscriptionCheckout(
      plan: plan,
      amountDueToday: plan.registrationEuro,
      monthlyAfter: plan.monthlyEuro,
      kind: PaymentCheckoutKind.newBusiness,
      businessName: businessName,
    );
  }

  String get formattedTotal {
    final n = amountDueToday;
    final s = n == n.roundToDouble() ? n.toInt().toString() : n.toStringAsFixed(2);
    return '${PaymentConfig.currencySymbol}$s';
  }

  String get title => 'Complete payment';

  String get subtitle => switch (kind) {
        PaymentCheckoutKind.registration =>
          'Binisoft Admin · ${plan.title} plan',
        PaymentCheckoutKind.newBusiness =>
          'New business · ${businessName ?? ''}',
      };

  String get primaryButtonLabel => switch (kind) {
        PaymentCheckoutKind.registration =>
          'Pay $formattedTotal and create account',
        PaymentCheckoutKind.newBusiness =>
          'Pay $formattedTotal and create business',
      };

  String get demoBannerMessage => switch (kind) {
        PaymentCheckoutKind.registration =>
          'Demo mode: no real charge yet. Stripe will be connected soon. '
          'Confirm below to create your account.',
        PaymentCheckoutKind.newBusiness =>
          'Demo mode: no real charge yet. Stripe will be connected soon. '
          'Confirm below to activate your new business.',
      };

  String get activationLineLabel => switch (kind) {
        PaymentCheckoutKind.registration => 'Registration (includes 1st month)',
        PaymentCheckoutKind.newBusiness =>
          'Business activation (includes 1st month)',
      };
}

/// Opens payment modal; returns `true` if user completed checkout.
Future<bool> showSubscriptionPaymentModal(
  BuildContext context, {
  required SubscriptionCheckout checkout,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _SubscriptionPaymentDialog(checkout: checkout),
  );
  return result ?? false;
}

/// Opens payment modal for registration.
Future<bool> showRegistrationPaymentModal(
  BuildContext context, {
  BusinessPlan? plan,
}) {
  final selectedPlan = plan ?? BusinessPlan.defaultPlan;
  return showSubscriptionPaymentModal(
    context,
    checkout: SubscriptionCheckout.registration(selectedPlan),
  );
}

/// Opens payment modal before creating an additional business.
Future<bool> showNewBusinessPaymentModal(
  BuildContext context, {
  required BusinessPlan plan,
  required String businessName,
}) {
  return showSubscriptionPaymentModal(
    context,
    checkout: SubscriptionCheckout.newBusiness(
      plan: plan,
      businessName: businessName,
    ),
  );
}

class _SubscriptionPaymentDialog extends StatefulWidget {
  const _SubscriptionPaymentDialog({required this.checkout});

  final SubscriptionCheckout checkout;

  @override
  State<_SubscriptionPaymentDialog> createState() => _SubscriptionPaymentDialogState();
}

class _SubscriptionPaymentDialogState extends State<_SubscriptionPaymentDialog> {
  final _cardName = TextEditingController();
  final _cardNumber = TextEditingController();
  final _expiry = TextEditingController();
  final _cvc = TextEditingController();
  var _method = _PaymentMethod.card;
  var _processing = false;
  var _agreed = false;

  SubscriptionCheckout get _checkout => widget.checkout;

  @override
  void dispose() {
    _cardName.dispose();
    _cardNumber.dispose();
    _expiry.dispose();
    _cvc.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    final l10n = context.l10n;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.paymentAcceptTermsRequired)),
      );
      return;
    }

    if (!PaymentConfig.demoMode && _method == _PaymentMethod.card) {
      if (_cardNumber.text.replaceAll(' ', '').length < 16) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paymentInvalidCard)),
        );
        return;
      }
    }

    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _processing = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    final primaryLabel = _checkout.kind == PaymentCheckoutKind.registration
        ? l10n.paymentPayRegistration(_checkout.formattedTotal)
        : l10n.paymentPayNewBusiness(_checkout.formattedTotal);
    final subtitle = _checkout.kind == PaymentCheckoutKind.registration
        ? l10n.paymentSubtitleRegistration(_checkout.plan.title)
        : l10n.paymentSubtitleNewBusiness(_checkout.businessName ?? '');
    final demoBanner = _checkout.kind == PaymentCheckoutKind.registration
        ? l10n.paymentDemoBannerRegistration
        : l10n.paymentDemoBannerNewBusiness;
    final activationLabel = _checkout.kind == PaymentCheckoutKind.registration
        ? l10n.paymentActivationRegistration
        : l10n.paymentActivationNewBusiness;

    return Dialog(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        side: BorderSide(color: colors.cardBorder),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 520, maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.paymentTitle,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _processing ? null : () => Navigator.pop(context, false),
                    icon: Icon(Icons.close_rounded, color: colors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (PaymentConfig.demoMode)
                        AppInfoBanner(
                          icon: Icons.science_outlined,
                          message: demoBanner,
                        ),
                      if (PaymentConfig.demoMode) const SizedBox(height: 16),
                      _OrderSummary(
                        checkout: _checkout,
                        colors: colors,
                        activationLabel: activationLabel,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.paymentMethod,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _MethodTile(
                        label: l10n.paymentCard,
                        icon: Icons.credit_card_rounded,
                        selected: _method == _PaymentMethod.card,
                        onTap: () => setState(() => _method = _PaymentMethod.card),
                      ),
                      const SizedBox(height: 8),
                      _MethodTile(
                        label: l10n.paymentPaypal,
                        icon: Icons.account_balance_wallet_outlined,
                        selected: _method == _PaymentMethod.paypal,
                        onTap: () => setState(() => _method = _PaymentMethod.paypal),
                      ),
                      if (_method == _PaymentMethod.card) ...[
                        const SizedBox(height: 16),
                        _CardFields(
                          nameController: _cardName,
                          numberController: _cardNumber,
                          expiryController: _expiry,
                          cvcController: _cvc,
                          enabled: !PaymentConfig.demoMode,
                        ),
                      ],
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _agreed,
                        onChanged: _processing
                            ? null
                            : (v) => setState(() => _agreed = v ?? false),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          l10n.paymentAcceptTerms,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: colors.textMuted,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: _processing || !_agreed ? null : _pay,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor:
                        context.isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                  ),
                  child: _processing
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.isDarkMode ? colors.textPrimary : Colors.white,
                          ),
                        )
                      : Text(
                          primaryLabel,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _processing ? null : () => Navigator.pop(context, false),
                child: Text(l10n.paymentCancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _PaymentMethod { card, paypal }

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.checkout,
    required this.colors,
    required this.activationLabel,
  });

  final SubscriptionCheckout checkout;
  final AppColorScheme colors;
  final String activationLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final plan = checkout.plan;
    final businessName = checkout.businessName;
    final monthly = plan.monthlyEuro;
    final monthlyLabel = monthly == monthly.roundToDouble()
        ? '${PaymentConfig.currencySymbol}${monthly.toInt()}'
        : '${PaymentConfig.currencySymbol}${monthly.toStringAsFixed(2)}';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      checkout.kind == PaymentCheckoutKind.newBusiness &&
                              businessName != null &&
                              businessName.isNotEmpty
                          ? businessName
                          : '${plan.title} · ${plan.maxProducts} products',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      checkout.kind == PaymentCheckoutKind.newBusiness
                          ? '${plan.title} · up to ${plan.maxProducts} products per business'
                          : plan.description,
                      style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _Line(
            label: activationLabel,
            value: checkout.formattedTotal,
            bold: false,
            colors: colors,
          ),
          const SizedBox(height: 8),
          _Line(
            label: l10n.paymentThenMonthly,
            value: '$monthlyLabel / month',
            bold: false,
            colors: colors,
          ),
          const SizedBox(height: 12),
          _Line(
            label: l10n.paymentTotalDueToday,
            value: checkout.formattedTotal,
            bold: true,
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    required this.bold,
    required this.colors,
  });

  final String label;
  final String value;
  final bool bold;
  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: bold ? 15 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: bold ? colors.textPrimary : colors.textMuted,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: bold ? 18 : 14,
            fontWeight: FontWeight.w700,
            color: bold ? colors.accent : colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? colors.accentSoft : colors.surface,
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(
              color: selected ? colors.accent : colors.cardBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? colors.accent : colors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 10),
              Icon(icon, size: 20, color: colors.textPrimary),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardFields extends StatelessWidget {
  const _CardFields({
    required this.nameController,
    required this.numberController,
    required this.expiryController,
    required this.cvcController,
    required this.enabled,
  });

  final TextEditingController nameController;
  final TextEditingController numberController;
  final TextEditingController expiryController;
  final TextEditingController cvcController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Field(
          label: 'Name on card',
          controller: nameController,
          enabled: enabled,
          hint: 'John Doe',
        ),
        const SizedBox(height: 12),
        _Field(
          label: 'Card number',
          controller: numberController,
          enabled: enabled,
          hint: '4242 4242 4242 4242',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _Field(
                label: 'Expiry',
                controller: expiryController,
                enabled: enabled,
                hint: 'MM/YY',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Field(
                label: 'CVC',
                controller: cvcController,
                enabled: enabled,
                hint: '123',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.enabled,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.inter(fontSize: 15, color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: enabled ? hint : 'Not required in demo mode',
            filled: true,
            fillColor: enabled ? colors.surfaceElevated : colors.chipBg,
          ),
        ),
      ],
    );
  }
}
