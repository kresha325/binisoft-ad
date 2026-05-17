import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';

/// Centered modal with scrollable body when content is tall.
Future<T?> showAppFormDialog<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  String saveLabel = 'Save',
  Future<bool> Function()? onSave,
  bool barrierDismissible = true,
  double maxWidth = 520,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) {
      final colors = ctx.appColors;
      final maxHeight = MediaQuery.sizeOf(ctx).height * 0.88;

      return Dialog(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          side: BorderSide(color: colors.cardBorder),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: _AppFormDialogBody(
            title: title,
            saveLabel: saveLabel,
            onSave: onSave,
            child: child,
          ),
        ),
      );
    },
  );
}

class _AppFormDialogBody extends StatefulWidget {
  const _AppFormDialogBody({
    required this.title,
    required this.saveLabel,
    required this.child,
    this.onSave,
  });

  final String title;
  final String saveLabel;
  final Widget child;
  final Future<bool> Function()? onSave;

  @override
  State<_AppFormDialogBody> createState() => _AppFormDialogBodyState();
}

class _AppFormDialogBodyState extends State<_AppFormDialogBody> {
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
                icon: Icon(Icons.close_rounded, size: 22, color: colors.textMuted),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: widget.child,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _saving ? null : _handleSave,
              child: _saving
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.isDarkMode ? colors.textPrimary : Colors.white,
                      ),
                    )
                  : Text(widget.saveLabel),
            ),
          ),
        ],
      ),
    );
  }
}
