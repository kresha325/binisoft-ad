import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_input_styles.dart';
import '../theme/app_theme.dart';

/// URL text field + "Choose File" button — matches JKR product/settings forms.
class ImageUrlUploadRow extends StatefulWidget {
  const ImageUrlUploadRow({
    super.key,
    required this.urlController,
    this.label = 'Image URL or Upload',
    this.onFilePicked,
    this.fileName,
  });

  final TextEditingController urlController;
  final String label;
  final void Function(PlatformFile file)? onFilePicked;
  final String? fileName;

  @override
  State<ImageUrlUploadRow> createState() => _ImageUrlUploadRowState();
}

class _ImageUrlUploadRowState extends State<ImageUrlUploadRow> {
  String? _pickedName;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'gif'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    setState(() => _pickedName = file.name);
    widget.urlController.clear();
    widget.onFilePicked?.call(file);
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _pickedName ?? widget.fileName;
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.fieldLabel(context)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: widget.urlController,
                style: AppInputStyles.fieldText(context),
                cursorColor: colors.accent,
                decoration: AppInputStyles.decoration(context, hintText: 'https://...'),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _pickFile,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                side: BorderSide(color: colors.cardBorder),
                foregroundColor: colors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                displayName != null ? _truncate(displayName) : 'Choose File',
                style: GoogleFonts.inter(fontSize: 13, color: colors.textPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _truncate(String name) {
    if (name.length <= 14) return name;
    return '${name.substring(0, 6)}...${name.substring(name.length - 5)}';
  }
}
