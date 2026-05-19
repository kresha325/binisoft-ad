import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';

/// Right-side panel (Add Product drawer) — respects light / dark theme.
Future<T?> showAppSideSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  String saveLabel = 'Save',
  Future<bool> Function()? onSave,
  /// When false, the sheet has no footer button (child handles submit).
  bool showFooter = true,
}) {
  final theme = Theme.of(context);

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.55 : 0.45,
    ),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final colors = dialogContext.appColors;
      final screenWidth = MediaQuery.sizeOf(dialogContext).width;
      final isMobile = AppBreakpoints.isMobile(dialogContext);
      final sheetWidth = isMobile ? screenWidth : 420.0;

      return Theme(
        data: theme,
        child: Align(
          alignment: isMobile ? Alignment.bottomCenter : Alignment.centerRight,
          child: Material(
            color: colors.surface,
            elevation: 16,
            shadowColor: Colors.black.withValues(alpha: 0.35),
            borderRadius: isMobile
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : null,
            clipBehavior: isMobile ? Clip.antiAlias : Clip.none,
            child: SizedBox(
              width: sheetWidth,
              height: isMobile
                  ? MediaQuery.sizeOf(dialogContext).height * 0.94
                  : MediaQuery.sizeOf(dialogContext).height,
              child: _AppSideSheetBody(
                title: title,
                saveLabel: saveLabel,
                onSave: onSave,
                showFooter: showFooter,
                child: child,
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final isMobile = AppBreakpoints.isMobile(context);
      final begin = isMobile ? const Offset(0, 1) : const Offset(1, 0);
      return SlideTransition(
        position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      );
    },
  );
}

class _AppSideSheetBody extends StatefulWidget {
  const _AppSideSheetBody({
    required this.title,
    required this.saveLabel,
    required this.child,
    this.onSave,
    this.showFooter = true,
  });

  final String title;
  final String saveLabel;
  final Widget child;
  final Future<bool> Function()? onSave;
  final bool showFooter;

  @override
  State<_AppSideSheetBody> createState() => _AppSideSheetBodyState();
}

class _AppSideSheetBodyState extends State<_AppSideSheetBody> {
  bool _saving = false;

  Future<void> _handleSave() async {
    if (widget.onSave == null) {
      Navigator.pop(context, true);
      return;
    }
    setState(() => _saving = true);
    final ok = await widget.onSave!();
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: colors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colors.cardBorder),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: widget.child,
          ),
        ),
        if (widget.showFooter) ...[
          Divider(height: 1, color: colors.cardBorder),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _handleSave,
                child: _saving
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.isDarkMode
                              ? colors.textPrimary
                              : Colors.white,
                        ),
                      )
                    : Text(widget.saveLabel),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
