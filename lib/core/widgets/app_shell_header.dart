import 'dart:ui';

import 'package:flutter/material.dart';

import '../layout/app_breakpoints.dart';
import 'glass_surface.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
/// Top bar shared by admin and platform shells.
class AppShellHeader extends StatelessWidget {
  const AppShellHeader({
    super.key,
    required this.leading,
    this.center,
    this.actions = const [],
    this.trailing,
  });

  final Widget leading;
  /// When set on mobile, uses a three-column bar (leading | center | actions).
  final Widget? center;
  final List<Widget> actions;
  final Widget? trailing;

  static double toolbarHeight(BuildContext context) =>
      AppBreakpoints.isMobile(context)
          ? AppDesign.shellToolbarHeightMobile
          : AppDesign.shellToolbarHeightDesktop;

  static BoxDecoration decoration(BuildContext context) {
    final colors = context.appColors;
    final isGlass = GlassSurface.useGlass(context);
    return BoxDecoration(
      color: isGlass
          ? Colors.white.withValues(alpha: 0.62)
          : colors.surface.withValues(alpha: 0.94),
      border: Border(bottom: BorderSide(color: colors.cardBorder)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isGlass ? 0.05 : 0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static Widget wrapBar(BuildContext context, {required Widget child}) {
    final bar = Container(
      decoration: decoration(context),
      child: SafeArea(
        bottom: false,
        child: child,
      ),
    );
    if (!GlassSurface.useGlass(context)) return bar;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: bar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final height =
        isMobile ? AppDesign.shellToolbarHeightMobile : AppDesign.shellToolbarHeightDesktop;
    final hPad = isMobile ? 12.0 : 24.0;

    final bar = AppShellHeader.wrapBar(
      context,
      child: SizedBox(
        height: height,
        child: center != null && isMobile
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: leading,
                    ),
                    Expanded(child: center!),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...actions,
                        if (trailing != null) trailing!,
                      ],
                    ),
                  ],
                ),
              )
            : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 0,
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.only(left: hPad),
                        child: leading,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: hPad),
                        child: Row(
                          children: [
                            const Spacer(),
                            ...actions,
                            if (trailing != null) ...[
                              SizedBox(width: isMobile ? 6 : 10),
                              trailing!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );

    return bar;
  }
}
