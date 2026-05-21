import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import 'glass_surface.dart';

/// List card for products, categories, offers (admin + superadmin).
class CatalogEntityCard extends StatelessWidget {
  const CatalogEntityCard({
    super.key,
    required this.title,
    this.subtitle,
    this.meta,
    this.leading,
    this.trailing,
    this.chips = const [],
    this.footer,
    this.onTap,
    this.dense = false,
  });

  final String title;
  final String? subtitle;
  final String? meta;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> chips;
  /// Full-width action below chips (e.g. view contest entries).
  final Widget? footer;
  final VoidCallback? onTap;
  /// Tighter padding and typography for product/category grids.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final pad = dense
        ? 10.0
        : (AppBreakpoints.isMobile(context) ? 14.0 : 16.0);
    final titleSize = dense ? 13.0 : 15.0;
    final subtitleSize = dense ? 12.0 : 13.0;

    final body = GlassSurface(
      borderRadius: BorderRadius.circular(dense ? AppDesign.radiusMd : AppDesign.radiusLg),
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: dense ? 10 : 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: dense ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      SizedBox(height: dense ? 2 : 4),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: subtitleSize,
                          color: colors.textMuted,
                          height: 1.2,
                        ),
                      ),
                    ],
                    if (meta != null && meta!.isNotEmpty) ...[
                      SizedBox(height: dense ? 3 : 6),
                      Text(
                        meta!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: dense ? 10 : 11,
                          fontWeight: FontWeight.w500,
                          color: colors.textMuted,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (chips.isNotEmpty) ...[
            SizedBox(height: dense ? 8 : 12),
            Wrap(spacing: 6, runSpacing: 4, children: chips),
          ],
          if (footer != null) ...[
            SizedBox(height: dense ? 8 : 12),
            footer!,
          ],
        ],
      ),
    );

    if (onTap == null) return body;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        child: body,
      ),
    );
  }
}
