import 'package:flutter/material.dart';

import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';

/// Bottom sheet on mobile; centered dialog on tablet/desktop (fixes web layout glitches).
Future<T?> showAppAdaptiveSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  bool barrierDismissible = true,
  double maxWidth = 480,
}) {
  final isMobile = AppBreakpoints.isMobile(context);

  if (isMobile) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: barrierDismissible,
      enableDrag: barrierDismissible,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final viewInsets = MediaQuery.viewInsetsOf(ctx);
        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: builder(ctx),
          ),
        );
      },
    );
  }

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) {
      final colors = ctx.appColors;
      final maxHeight = MediaQuery.sizeOf(ctx).height * 0.88;

      return Dialog(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusXl),
          side: BorderSide(color: colors.cardBorder),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: builder(ctx),
        ),
      );
    },
  );
}

/// Drag handle shown only for bottom-sheet presentation.
Widget? adaptiveSheetDragHandle(BuildContext context, {bool show = true}) {
  if (!show || !AppBreakpoints.isMobile(context)) return null;
  final colors = context.appColors;
  return Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: colors.cardBorder,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ),
  );
}
