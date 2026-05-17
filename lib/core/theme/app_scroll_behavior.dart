import 'package:flutter/material.dart';

/// Scroll without persistent scrollbars (wheel / trackpad / touch still work).
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
