import 'package:flutter/material.dart';

import '../layout/app_breakpoints.dart';

/// Makes shell header actions full-width on mobile.
class MobileHeaderAction extends StatelessWidget {
  const MobileHeaderAction({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!AppBreakpoints.isMobile(context)) return child;
    return SizedBox(width: double.infinity, child: child);
  }
}
