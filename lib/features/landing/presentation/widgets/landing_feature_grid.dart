import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/theme/app_theme.dart';

class LandingFeatureGrid extends StatelessWidget {
  const LandingFeatureGrid({super.key});

  static const _features = [
    (
      Icons.inventory_2_outlined,
      'Product catalog',
      'Manage products, images, pricing, and status from one place.',
    ),
    (
      Icons.hub_outlined,
      'Public REST API',
      'Auto-generated endpoints per business slug — no auth for catalog reads.',
    ),
    (
      Icons.business_center_outlined,
      'Multi-business',
      'Switch businesses, separate catalogs, and independent API slugs.',
    ),
    (
      Icons.tune_outlined,
      'Custom fields',
      'Define attributes, colors, and templates that flow into the API.',
    ),
    (
      Icons.dark_mode_outlined,
      'Dark mode',
      'Polished UI with theme sync and readable dashboard backgrounds.',
    ),
    (
      Icons.notifications_outlined,
      'Live updates',
      'In-app notifications for plan changes, new businesses, and more.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 900 ? 3 : (width >= 560 ? 2 : 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Built for modern commerce teams',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Everything you need to run Binisoft admin on phone, tablet, or desktop.',
          style: GoogleFonts.inter(fontSize: 16, color: colors.textMuted, height: 1.45),
        ),
        const SizedBox(height: 28),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: cols == 1 ? 1.35 : 1.15,
          ),
          itemCount: _features.length,
          itemBuilder: (context, i) {
            final (icon, title, body) = _features[i];
            return _FeatureCard(icon: icon, title: title, body: body);
          },
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        border: Border.all(color: colors.cardBorder),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            ),
            child: Icon(icon, color: colors.accent, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted, height: 1.45),
          ),
        ],
      ),
    );
  }
}
