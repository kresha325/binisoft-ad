import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_input_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_image.dart';

/// Up to [kMaxProductImages] photos; toggle which are active on the public shop.
class ProductImagesEditor extends StatefulWidget {
  const ProductImagesEditor({
    super.key,
    required this.initialImages,
    required this.onChanged,
    this.onPendingFilesChanged,
  });

  final List<ProductImage> initialImages;
  final ValueChanged<List<ProductImage>> onChanged;
  final ValueChanged<List<PlatformFile>>? onPendingFilesChanged;

  @override
  State<ProductImagesEditor> createState() => ProductImagesEditorState();
}

class ProductImagesEditorState extends State<ProductImagesEditor> {
  late List<ProductImage> _images;
  final List<PlatformFile> _pendingFiles = [];
  final _urlController = TextEditingController();

  List<ProductImage> get images => List.unmodifiable(_images);
  List<PlatformFile> get pendingFiles => List.unmodifiable(_pendingFiles);

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged(_images);
    widget.onPendingFilesChanged?.call(List.from(_pendingFiles));
  }

  int get _totalCount => _images.length + _pendingFiles.length;

  Future<void> _pickFiles() async {
    final l10n = context.l10n;
    final remaining = kMaxProductImages - _totalCount;
    if (remaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.productImagesMax(kMaxProductImages))),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'gif'],
      withData: true,
      allowMultiple: true,
    );
    if (result == null || result.files.isEmpty) return;

    setState(() {
      for (final file in result.files.take(remaining)) {
        _pendingFiles.add(file);
      }
    });
    _notify();
  }

  void _addUrl() {
    final l10n = context.l10n;
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    if (_totalCount >= kMaxProductImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.productImagesMax(kMaxProductImages))),
      );
      return;
    }
    setState(() {
      _images.add(ProductImage(url: url, active: true));
      _urlController.clear();
    });
    _notify();
  }

  void _removeAt(int index) {
    setState(() => _images.removeAt(index));
    _notify();
  }

  void _removePending(int index) {
    setState(() => _pendingFiles.removeAt(index));
    _notify();
  }

  void _toggleActive(int index, bool value) {
    setState(() => _images[index] = _images[index].copyWith(active: value));
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.productImagesTitle, style: AppTextStyles.fieldLabel(context)),
        const SizedBox(height: 4),
        Text(
          l10n.productImagesSubtitle(kMaxProductImages),
          style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < _images.length; i++)
              _ImageTile(
                imageUrl: _images[i].url,
                active: _images[i].active,
                onToggle: (v) => _toggleActive(i, v),
                onRemove: () => _removeAt(i),
              ),
            for (var i = 0; i < _pendingFiles.length; i++)
              _PendingTile(
                name: _pendingFiles[i].name,
                onRemove: () => _removePending(i),
              ),
            if (_totalCount < kMaxProductImages)
              _AddTile(onTap: _pickFiles),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _urlController,
                style: AppInputStyles.fieldText(context),
                decoration: AppInputStyles.decoration(
                  context,
                  hintText: 'https://...',
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _addUrl,
              child: Text(l10n.productImagesAddUrl),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.imageUrl,
    required this.active,
    required this.onToggle,
    required this.onRemove,
  });

  final String imageUrl;
  final bool active;
  final ValueChanged<bool> onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return SizedBox(
      width: 96,
      child: Column(
        children: [
          Stack(
            children: [
              Opacity(
                opacity: active ? 1 : 0.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 88,
                    height: 88,
                    color: colors.surface,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.broken_image_outlined,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: InkWell(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FilterChip(
            label: Text(l10n.productImagesActive, style: const TextStyle(fontSize: 11)),
            selected: active,
            onSelected: onToggle,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            showCheckmark: false,
          ),
        ],
      ),
    );
  }
}

class _PendingTile extends StatelessWidget {
  const _PendingTile({required this.name, required this.onRemove});

  final String? name;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Stack(
      children: [
        Container(
          width: 88,
          height: 88,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.accent, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, color: colors.accent, size: 28),
              if (name != null)
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 9, color: colors.textMuted),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: Material(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onRemove,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.cardBorder, style: BorderStyle.solid),
        ),
        child: Icon(Icons.add_photo_alternate_outlined, color: colors.textMuted, size: 32),
      ),
    );
  }
}
