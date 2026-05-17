import 'package:flutter/material.dart';

/// Shared responsive breakpoints for admin UI.
abstract final class AppBreakpoints {
  static const double mobile = 640;
  static const double tablet = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTabletOrSmaller(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tablet;

  static EdgeInsets screenPadding(BuildContext context) {
    final h = isMobile(context) ? 16.0 : 24.0;
    final top = isMobile(context) ? 12.0 : 24.0;
    final bottom = isMobile(context) ? 20.0 : 32.0;
    return EdgeInsets.fromLTRB(h, top, h, bottom);
  }
}
