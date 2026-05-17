import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';

/// Bordered icon control used in app shells and toolbars.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.danger = false,
    this.child,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool danger;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fg = danger ? colors.danger : colors.textPrimary;
    final border = danger ? colors.danger.withValues(alpha: 0.35) : colors.cardBorder;

    final box = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: border),
      ),
      alignment: Alignment.center,
      child: child ?? Icon(icon, size: 20, color: fg),
    );

    // No InkWell when null — allows parent [PopupMenuButton] to receive taps.
    final button = onPressed == null
        ? box
        : Material(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
              child: box,
            ),
          );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
