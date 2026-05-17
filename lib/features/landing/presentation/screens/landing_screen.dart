import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_download_links.dart';
import '../../../../core/constants/branding.dart';
import '../../../../core/constants/business_plans.dart';
import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/services/app_download_service.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/client_platform.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../widgets/landing_download_section.dart';
import '../widgets/landing_feature_grid.dart';
import '../widgets/landing_pricing_section.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Public landing is always dark (independent of user theme preference).
    return Theme(
      data: AppTheme.dark(),
      child: Builder(
        builder: (context) {
          final colors = context.appColors;
          final suggested = suggestedDownloadPlatform;
          final isWide = MediaQuery.sizeOf(context).width >= 900;

          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                const _LandingBackground(),
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _LandingNavBar(colors: colors)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppBreakpoints.isMobile(context) ? 20 : 48,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1100),
                            child: Column(
                              children: [
                                SizedBox(height: isWide ? 48 : 32),
                                _HeroSection(
                                  colors: colors,
                                  isWide: isWide,
                                  suggested: suggested,
                                ),
                                const SizedBox(height: 56),
                                const LandingFeatureGrid(),
                                const SizedBox(height: 56),
                                LandingDownloadSection(suggested: suggested),
                                const SizedBox(height: 56),
                                const LandingPricingSection(),
                                const SizedBox(height: 64),
                                _Footer(colors: colors),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LandingBackground extends StatelessWidget {
  const _LandingBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF060A14),
            Color(0xFF0F172A),
            Color(0xFF132238),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: _Orb(
              size: 320,
              color: AppColors.accentTeal.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -100,
            child: _Orb(
              size: 280,
              color: AppColors.navy.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _LandingNavBar extends StatelessWidget {
  const _LandingNavBar({required this.colors});

  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 12),
        child: Row(
          children: [
            const BrandLogo(compact: true),
            const Spacer(),
            if (!isMobile)
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Log in'),
              ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () => context.go('/register'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.accent,
                foregroundColor: const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Get started'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.colors,
    required this.isWide,
    required this.suggested,
  });

  final AppColorScheme colors;
  final bool isWide;
  final ClientPlatform suggested;

  @override
  Widget build(BuildContext context) {
    final starter = BusinessPlan.defaultPlan;
    final heroText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.accentSoft,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
          ),
          child: Text(
            'REAL-TIME BUSINESS ADMIN',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: colors.accent,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Run your catalog.\nShip your API.\nGrow faster.',
          style: GoogleFonts.inter(
            fontSize: isWide ? 48 : 34,
            fontWeight: FontWeight.w800,
            height: 1.08,
            letterSpacing: -1.2,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${AppBranding.appTitle} — ${AppBranding.splashTagline}. '
          'Products, categories, custom fields, and a public REST API for every business you manage.',
          style: GoogleFonts.inter(
            fontSize: isWide ? 18 : 16,
            height: 1.5,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'From ${starter.registrationPriceLabel} · up to 100, 200, or 500 products · '
          'Enterprise — contact support',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.accent,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => AppDownloadService.openSmartDownload(context),
              icon: const Icon(Icons.download_rounded, size: 20),
              label: Text(_smartDownloadLabel(suggested)),
              style: FilledButton.styleFrom(
                backgroundColor: colors.accent,
                foregroundColor: const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.login_rounded, size: 20),
              label: const Text('Open web dashboard'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              ),
            ),
          ],
        ),
        if (kIsWeb && suggested != ClientPlatform.unknown) ...[
          const SizedBox(height: 12),
          Text(
            'Detected: ${AppDownloadLinks.subtitleFor(suggested)} — we\'ll open the right store.',
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
          ),
        ],
      ],
    );

    final mockCard = _DashboardMockCard(colors: colors);

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [heroText, const SizedBox(height: 32), mockCard],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: heroText),
        const SizedBox(width: 40),
        Expanded(child: mockCard),
      ],
    );
  }

  static String _smartDownloadLabel(ClientPlatform suggested) {
    if (suggested == ClientPlatform.unknown) return 'Download app';
    return 'Download for ${AppDownloadLinks.subtitleFor(suggested)}';
  }
}

class _DashboardMockCard extends StatelessWidget {
  const _DashboardMockCard({required this.colors});

  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        border: Border.all(color: colors.cardBorder),
        boxShadow: AppShadows.authCard,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
              ),
              const Spacer(),
              Text(
                'Dashboard preview',
                style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _MiniStat(colors: colors, label: 'Products', value: '248'),
              const SizedBox(width: 12),
              _MiniStat(colors: colors, label: 'Active', value: '231'),
              const SizedBox(width: 12),
              _MiniStat(colors: colors, label: 'Categories', value: '18'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: 0.72,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Catalog health · API live',
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.colors,
    required this.label,
    required this.value,
  });

  final AppColorScheme colors;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.colors});

  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandLogo(compact: true),
        const SizedBox(height: 12),
        Text(
          AppBranding.tagline,
          style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 8,
          children: [
            TextButton(onPressed: () => context.go('/login'), child: const Text('Log in')),
            TextButton(onPressed: () => context.go('/register'), child: const Text('Register')),
            TextButton(
              onPressed: () => AppDownloadService.openSmartDownload(context),
              child: const Text('Download'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          '© ${DateTime.now().year} Binisoft · ${AppBranding.appTitle}',
          style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
