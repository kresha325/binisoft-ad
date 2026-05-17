import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/dashboard_backgrounds.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../providers/background_preview_providers.dart';

class BackgroundPickerSection extends ConsumerStatefulWidget {
  const BackgroundPickerSection({
    super.key,
    required this.initialPresetId,
    required this.initialCustomUrl,
    required this.initialOverlayOpacity,
    required this.onChanged,
  });

  final String? initialPresetId;
  final String? initialCustomUrl;
  final double initialOverlayOpacity;
  final void Function(String? presetId, String? customUrl, double overlayOpacity)
      onChanged;

  @override
  ConsumerState<BackgroundPickerSection> createState() => _BackgroundPickerSectionState();
}

class _BackgroundPickerSectionState extends ConsumerState<BackgroundPickerSection> {
  late String? _presetId;
  late final TextEditingController _customUrl;
  late double _overlayOpacity;
  PlatformFile? _backgroundFile;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _presetId = widget.initialPresetId;
    if (_presetId == null || _presetId!.isEmpty) {
      _presetId = DashboardBackgrounds.noneId;
    }
    _customUrl = TextEditingController(text: widget.initialCustomUrl ?? '');
    _overlayOpacity = DashboardBackgrounds.resolveOverlayOpacity(
      widget.initialOverlayOpacity,
    );
  }

  bool get _hasBackground => DashboardBackgrounds.hasActiveBackground(
        presetId: _presetId,
        customImageUrl: _customUrl.text,
      );

  @override
  void dispose() {
    _customUrl.dispose();
    super.dispose();
  }

  void _notify() {
    final preset = _presetId == DashboardBackgrounds.noneId ? null : _presetId;
    final custom = _customUrl.text.trim();
    widget.onChanged(
      preset,
      custom.isEmpty ? null : custom,
      _overlayOpacity,
    );
  }

  Future<void> _persistBackground() async {
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    final custom = _customUrl.text.trim();
    final hasCustom = custom.isNotEmpty;
    final preset = !hasCustom &&
            _presetId != null &&
            _presetId != DashboardBackgrounds.noneId
        ? _presetId
        : null;

    try {
      await ref.read(businessRepositoryProvider).updateProfile(
            businessId: businessId,
            name: ref.read(currentBusinessProvider).valueOrNull?.name ?? '',
            description: ref.read(currentBusinessProvider).valueOrNull?.description,
            logoUrl: ref.read(currentBusinessProvider).valueOrNull?.logoUrl,
            backgroundPresetId: preset,
            backgroundImageUrl: hasCustom ? custom : null,
            backgroundOverlayOpacity: _hasBackground ? _overlayOpacity : null,
          );
      ref.invalidate(currentBusinessProvider);
      ref.read(backgroundOverlayPreviewProvider.notifier).state = null;
      _notify();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(e)),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  Future<void> _selectPreset(String? id) async {
    setState(() {
      _presetId = id ?? DashboardBackgrounds.noneId;
      if (id != null && id != DashboardBackgrounds.noneId) {
        _customUrl.clear();
        _backgroundFile = null;
      }
    });
    await _persistBackground();
    if (mounted && id != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Background updated')),
      );
    }
  }

  Future<void> _pickAndUpload() async {
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    setState(() => _uploading = true);
    try {
      final url = await ref.read(mediaUploadServiceProvider).uploadDashboardBackground(
            businessId: businessId,
            file: result.files.first,
          );
      setState(() {
        _backgroundFile = result.files.first;
        _customUrl.text = url;
        _presetId = DashboardBackgrounds.noneId;
      });
      await _persistBackground();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Background image uploaded')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(e)),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = colors.accent;
    final width = MediaQuery.sizeOf(context).width;
    final crossCount = width >= 900 ? 3 : (width >= 560 ? 2 : 1);

    final isDark = context.isDarkMode;

    return AppSectionCard(
      title: 'Dashboard background',
      subtitle: isDark
          ? 'Wallpaper behind admin pages. Use the overlay slider so text stays readable.'
          : 'Background images apply in dark mode only. Light mode uses a glass style without wallpaper.',
      icon: Icons.wallpaper_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isDark)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20, color: accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Switch to dark mode to preview and change your dashboard wallpaper.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: colors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          IgnorePointer(
            ignoring: !isDark,
            child: Opacity(
              opacity: isDark ? 1 : 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
          GridView.count(
            crossAxisCount: crossCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.55,
            children: [
              _BackgroundTile(
                title: 'Default',
                gradient: LinearGradient(
                  colors: [
                    colors.scaffoldBg,
                    colors.cardBorder,
                  ],
                ),
                selected: _presetId == DashboardBackgrounds.noneId &&
                    _customUrl.text.trim().isEmpty,
                onTap: () => _selectPreset(DashboardBackgrounds.noneId),
              ),
              for (final preset in DashboardBackgrounds.presets)
                _BackgroundTile(
                  title: preset.title,
                  gradient: preset.previewGradient,
                  assetPath: preset.assetPath,
                  selected: _presetId == preset.id && _customUrl.text.trim().isEmpty,
                  accentColor: accent,
                  borderColor: colors.cardBorder,
                  textColor: colors.textPrimary,
                  onTap: () => _selectPreset(preset.id),
                ),
            ],
          ),
          if (_hasBackground) ...[
            const SizedBox(height: 24),
            Text(
              'Background fade',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.isDarkMode
                  ? 'Lower = more visible wallpaper. Higher = darker overlay for readability.'
                  : 'Lower = more visible wallpaper. Higher = lighter, easier to read.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colors.textMuted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _overlayOpacity,
                    min: DashboardBackgrounds.minOverlayOpacity,
                    max: DashboardBackgrounds.maxOverlayOpacity,
                    divisions: 46,
                    label: '${(_overlayOpacity * 100).round()}%',
                    onChanged: (v) {
                      setState(() => _overlayOpacity = v);
                      ref.read(backgroundOverlayPreviewProvider.notifier).state = v;
                      _notify();
                    },
                    onChangeEnd: (_) => _persistBackground(),
                  ),
                ),
                SizedBox(
                  width: 44,
                  child: Text(
                    '${(_overlayOpacity * 100).round()}%',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: accent,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Custom background',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Image URL',
            controller: _customUrl,
            hint: 'https://…',
            onChanged: (_) {
              if (_customUrl.text.trim().isNotEmpty) {
                setState(() => _presetId = DashboardBackgrounds.noneId);
              }
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _persistBackground,
              child: const Text('Apply custom URL'),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _uploading ? null : _pickAndUpload,
            icon: _uploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_outlined, size: 18),
            label: Text(_backgroundFile?.name ?? 'Upload image file'),
            style: OutlinedButton.styleFrom(
              foregroundColor: accent,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundTile extends StatelessWidget {
  const _BackgroundTile({
    required this.title,
    required this.gradient,
    required this.selected,
    required this.onTap,
    this.assetPath,
    this.accentColor,
    this.borderColor,
    this.textColor,
  });

  final String title;
  final Gradient gradient;
  final String? assetPath;
  final bool selected;
  final VoidCallback onTap;
  final Color? accentColor;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = accentColor ?? (context.isDarkMode ? AppColors.accentTeal : AppColors.navy);
    final border = borderColor ?? colors.cardBorder;
    final text = textColor ?? colors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? accent : border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                  child: assetPath != null
                      ? Image.asset(
                          assetPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
                        )
                      : DecoratedBox(
                          decoration: BoxDecoration(gradient: gradient),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: text,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle, size: 16, color: accent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
