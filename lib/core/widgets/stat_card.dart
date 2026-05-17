import 'package:flutter/material.dart';

import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    final child = GlassSurface(
      borderRadius: BorderRadius.circular(AppDesign.radiusLg),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : AppDesign.cardPaddingDesktop,
        vertical: isMobile ? 12 : AppDesign.cardPaddingDesktop,
      ),
      child: isMobile ? _buildMobileRow(context) : _buildDesktopColumn(context),
    );

    if (onTap == null) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        child: child,
      ),
    );
  }

  Widget _buildMobileRow(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.accentSoft,
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
          child: Icon(icon, size: 18, color: colors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.statLabel(context),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppTextStyles.statValue(context).copyWith(fontSize: 22),
        ),
      ],
    );
  }

  Widget _buildDesktopColumn(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.accentSoft,
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
          child: Icon(icon, size: 18, color: colors.accent),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.statLabel(context),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTextStyles.statValue(context).copyWith(fontSize: 30),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
