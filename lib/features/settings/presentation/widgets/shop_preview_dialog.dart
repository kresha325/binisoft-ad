import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/utils/open_external_url.dart';
import '../../../business/domain/entities/site_config.dart';
import '../../domain/shop_preview_data.dart';

Color? _parseHexColor(String? hex) {
  final h = hex?.trim().replaceFirst('#', '') ?? '';
  if (h.length != 6) return null;
  try {
    return Color(int.parse('FF$h', radix: 16));
  } catch (_) {
    return null;
  }
}

Future<void> showShopPreviewDialog(
  BuildContext context,
  ShopPreviewData data,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => _ShopPreviewDialog(data: data),
  );
}

class _ShopPreviewDialog extends StatelessWidget {
  const _ShopPreviewDialog({required this.data});

  final ShopPreviewData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final theme = data.siteConfig?.theme;
    final accent = _parseHexColor(theme?.accent) ?? const Color(0xFFFF6B35);
    final pageBg = _parseHexColor(theme?.background) ?? const Color(0xFFF5F3F0);
    final textColor = _parseHexColor(theme?.text) ?? const Color(0xFF1C1917);
    final slug = data.slug?.trim() ?? '';
    final liveUrl = slug.isNotEmpty ? AppConstants.publicShopUrl(slug) : null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.shopPreviewTitle,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.35)),
                ),
                child: Text(
                  l10n.shopPreviewDraftNote,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.4,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _ShopPreviewFrame(
                  data: data,
                  pageBg: pageBg,
                  textColor: textColor,
                  accent: accent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  if (liveUrl != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => openExternalUrl(liveUrl),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: Text(l10n.shopPreviewOpenLive),
                      ),
                    ),
                  if (liveUrl != null) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.close),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopPreviewFrame extends StatelessWidget {
  const _ShopPreviewFrame({
    required this.data,
    required this.pageBg,
    required this.textColor,
    required this.accent,
  });

  final ShopPreviewData data;
  final Color pageBg;
  final Color textColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tagline = data.heroTagline?.trim() ?? '';
    final about = data.aboutBio?.trim() ?? '';
    final loc = data.locationLine;
    final enabledSections = _enabledSectionLabels(context, data.siteConfig);

    return Container(
      decoration: BoxDecoration(
        color: pageBg,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        border: Border.all(color: textColor.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroPreview(
            data: data,
            textColor: textColor,
            accent: accent,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (enabledSections.isNotEmpty) ...[
                  Text(
                    l10n.shopPreviewSections,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.06,
                      color: textColor.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: enabledSections
                        .map(
                          (label) => Chip(
                            label: Text(label, style: const TextStyle(fontSize: 11)),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            backgroundColor: accent.withValues(alpha: 0.12),
                            side: BorderSide(color: accent.withValues(alpha: 0.25)),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (about.isNotEmpty) ...[
                  Text(
                    'Rreth nesh',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    about,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.45,
                      color: textColor.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (loc.isNotEmpty ||
                    (data.orderPhone?.trim().isNotEmpty ?? false) ||
                    (data.openingHours?.trim().isNotEmpty ?? false)) ...[
                  Text(
                    'Kontakt',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (loc.isNotEmpty) _PreviewRow(icon: Icons.location_on_outlined, text: loc),
                  if (data.orderPhone?.trim().isNotEmpty ?? false)
                    _PreviewRow(icon: Icons.phone_outlined, text: data.orderPhone!.trim()),
                  if (data.openingHours?.trim().isNotEmpty ?? false)
                    _PreviewRow(icon: Icons.schedule_outlined, text: data.openingHours!.trim()),
                ],
                if (tagline.isEmpty && about.isEmpty && loc.isEmpty)
                  Text(
                    l10n.shopPreviewEmptyHint,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: textColor.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _enabledSectionLabels(BuildContext context, SiteConfig? config) {
    final cfg = config?.mergeWithDefaults() ?? SiteConfig.defaults();
    final l10n = context.l10n;
    final labels = <String>[];
    for (final s in cfg.sections) {
      if (!s.enabled) continue;
      labels.add(s.navLabel ?? s.title ?? _defaultSectionLabel(l10n, s.id));
    }
    return labels;
  }

  String _defaultSectionLabel(dynamic l10n, String id) {
    switch (id) {
      case SiteConfig.sectionHero:
        return l10n.siteSectionHero;
      case SiteConfig.sectionOffers:
        return l10n.siteSectionOffers;
      case SiteConfig.sectionProducts:
        return l10n.siteSectionProducts;
      case SiteConfig.sectionServices:
        return l10n.siteSectionServices;
      case SiteConfig.sectionAbout:
        return l10n.siteSectionAbout;
      case SiteConfig.sectionGallery:
        return l10n.siteSectionGallery;
      case SiteConfig.sectionContact:
        return l10n.siteSectionContact;
      default:
        return id;
    }
  }
}

class _HeroPreview extends StatelessWidget {
  const _HeroPreview({
    required this.data,
    required this.textColor,
    required this.accent,
  });

  final ShopPreviewData data;
  final Color textColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cover = data.coverUrl?.trim() ?? '';
    final logo = data.logoUrl?.trim() ?? '';
    final name = data.name.trim().isEmpty ? 'Dyqani' : data.name.trim();
    final tagline = data.heroTagline?.trim() ?? '';
    final eyebrow = data.businessTypeLabel?.trim() ?? '';
    final onCover = cover.isNotEmpty;

    return Stack(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.06),
            image: cover.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(cover),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  )
                : null,
          ),
          child: cover.isNotEmpty
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                )
              : null,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (logo.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        logo,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _LogoFallback(accent: accent, name: name),
                      ),
                    )
                  else
                    _LogoFallback(accent: accent, name: name),
                  const Spacer(),
                  Icon(Icons.shopping_cart_outlined, color: onCover ? Colors.white : textColor),
                ],
              ),
              const SizedBox(height: 48),
              if (eyebrow.isNotEmpty)
                Text(
                  eyebrow,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: onCover ? accent : accent,
                  ),
                ),
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: onCover ? Colors.white : textColor,
                ),
              ),
              if (tagline.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  tagline,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.35,
                    color: onCover
                        ? Colors.white.withValues(alpha: 0.92)
                        : textColor.withValues(alpha: 0.75),
                  ),
                ),
              ],
              if (data.locationLine.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: onCover ? Colors.white70 : textColor.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data.locationLine,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: onCover ? Colors.white70 : textColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback({required this.accent, required this.name});

  final Color accent;
  final String name;

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'B';
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        letter,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 13, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
