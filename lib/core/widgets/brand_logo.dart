import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/branding.dart';
import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_theme.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.compact = false,
    this.showTagline = false,
    this.logoOnly = false,
  });

  /// Header: logo + "Admin Dashboard". Auth: logo + tagline only.
  final bool compact;
  final bool showTagline;
  /// Logo image only (no "Admin Dashboard" text).
  final bool logoOnly;

  @override
  Widget build(BuildContext context) {
    if (showTagline && !compact) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LogoImage(height: 56),
          const SizedBox(height: 10),
          Text(
            AppBranding.tagline,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.6,
            ),
          ),
        ],
      );
    }

    final colors = context.appColors;
    final isMobile = compact && AppBreakpoints.isMobile(context);
    final height = compact
        ? (isMobile
            ? AppBranding.headerLogoHeightMobile
            : AppBranding.headerLogoHeightDesktop)
        : 44.0;

    if (logoOnly || isMobile || compact) {
      final isHeader = compact || logoOnly || isMobile;
      final offsetX = isHeader && !isMobile ? AppBranding.headerLogoVisualOffsetX : 0.0;
      final logo = Transform.translate(
        offset: Offset(offsetX, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: _LogoImage(
            height: height,
            header: isHeader,
            compactHeader: isHeader && isMobile,
          ),
        ),
      );
      if (!isMobile) return logo;
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: logo,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _LogoImage(height: compact ? 34 : 44),
        const SizedBox(width: 10),
        Text(
          'Admin Dashboard',
          style: GoogleFonts.inter(
            fontSize: compact ? 15 : 18,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage({
    required this.height,
    this.header = false,
    this.compactHeader = false,
  });

  final double height;
  final bool header;
  final bool compactHeader;

  @override
  Widget build(BuildContext context) {
    final asset = AppBranding.logoAssetFor(Theme.of(context).brightness);
    final widthScale = header
        ? (compactHeader ? 1.0 : AppBranding.headerLogoWidthScale)
        : 1.0;
    final width = height * AppBranding.logoAspectRatio * widthScale;

    return Image.asset(
      asset,
      height: height,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => _FallbackMark(size: height, width: width),
    );
  }
}

class _FallbackMark extends StatelessWidget {
  const _FallbackMark({required this.size, required this.width});

  final double size;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentTeal, AppColors.navy],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        'BINISOFT',
        style: GoogleFonts.inter(
          fontSize: size * 0.22,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
