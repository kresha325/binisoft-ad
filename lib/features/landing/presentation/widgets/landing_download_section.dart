import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_download_links.dart';
import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/services/app_download_service.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/client_platform.dart';

class LandingDownloadSection extends StatelessWidget {
  const LandingDownloadSection({super.key, required this.suggested});

  final ClientPlatform suggested;

  static const _platforms = [
    ...landingDownloadPlatforms,
    ClientPlatform.web,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = AppBreakpoints.isMobile(context);
    final width = MediaQuery.sizeOf(context).width;
    final singleRow = width >= 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Download the app',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Install on your device or use the web dashboard. We detect your platform when possible.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.inter(fontSize: 16, color: colors.textMuted, height: 1.45),
        ),
        const SizedBox(height: 24),
        if (singleRow)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _platforms.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: _StoreCard(
                    platform: _platforms[i],
                    highlighted: _platforms[i] == suggested,
                    compact: true,
                    onTap: () => AppDownloadService.openForPlatform(context, _platforms[i]),
                  ),
                ),
              ],
            ],
          )
        else
          GridView.count(
            crossAxisCount: width >= 500 ? 2 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: isMobile ? 1.5 : 1.25,
            children: [
              for (final p in _platforms)
                _StoreCard(
                  platform: p,
                  highlighted: p == suggested,
                  onTap: () => AppDownloadService.openForPlatform(context, p),
                ),
            ],
          ),
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: () => AppDownloadService.openSmartDownload(context),
            icon: const Icon(Icons.devices_other_rounded, size: 18),
            label: const Text('Not sure? Choose platform'),
          ),
        ),
      ],
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({
    required this.platform,
    required this.highlighted,
    required this.onTap,
    this.compact = false,
  });

  final ClientPlatform platform;
  final bool highlighted;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasLink = platform == ClientPlatform.web ||
        (AppDownloadLinks.urlFor(platform)?.isNotEmpty ?? false);
    final pad = compact ? 12.0 : 20.0;
    final iconSize = compact ? 26.0 : 36.0;
    final titleSize = compact ? 13.0 : 16.0;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppDesign.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesign.radiusLg),
            border: Border.all(
              color: highlighted ? colors.accent : colors.cardBorder,
              width: highlighted ? 2 : 1,
            ),
            boxShadow: highlighted ? AppShadows.card(context) : null,
          ),
          padding: EdgeInsets.all(pad),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (highlighted)
                Padding(
                  padding: EdgeInsets.only(bottom: compact ? 6 : 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.accentSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'RECOMMENDED',
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: colors.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              Icon(_iconFor(platform), size: iconSize, color: colors.accent),
              SizedBox(height: compact ? 8 : 12),
              Text(
                AppDownloadLinks.labelFor(platform),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppDownloadLinks.subtitleFor(platform),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: compact ? 10 : 12, color: colors.textMuted),
              ),
              if (!hasLink && platform != ClientPlatform.web) ...[
                const SizedBox(height: 4),
                Text(
                  'Coming soon',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(ClientPlatform p) => switch (p) {
        ClientPlatform.ios => Icons.apple,
        ClientPlatform.android => Icons.android,
        ClientPlatform.macos => Icons.laptop_mac_rounded,
        ClientPlatform.windows => Icons.desktop_windows_rounded,
        ClientPlatform.linux => Icons.terminal_rounded,
        ClientPlatform.web => Icons.language_rounded,
        ClientPlatform.unknown => Icons.download_rounded,
      };
}
