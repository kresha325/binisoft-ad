import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/preset_colors.dart';

/// Dot swatches — saves `{name, hex}` on select.
class ColorSwatchPicker extends StatelessWidget {
  const ColorSwatchPicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.presets = presetProductColors,
  });

  final String label;
  final dynamic value;
  final ValueChanged<Map<String, String>?> onChanged;
  final List<PresetColor> presets;

  static Color parseHexColor(String hex) {
    final h = hex.replaceFirst('#', '').trim();
    if (h.length == 6) {
      return Color(int.parse('FF$h', radix: 16));
    }
    return const Color(0xFFE5E7EB);
  }

  @override
  Widget build(BuildContext context) {
    final selected = SelectedProductColor.fromDynamic(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.fieldLabel(context)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final preset in presets)
              _ColorDot(
                color: parseHexColor(preset.hex),
                selected: selected?.matches(preset) ?? false,
                onTap: () => onChanged(preset.toValue()),
              ),
          ],
        ),
        if (selected != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected.hex.isNotEmpty
                        ? parseHexColor(selected.hex)
                        : const Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected.hex.toUpperCase() == '#FFFFFF'
                          ? AppColors.cardBorder
                          : Colors.transparent,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.name,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.appColors.textPrimary,
                        ),
                      ),
                      if (selected.hex.isNotEmpty)
                        Text(
                          selected.hex,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.appColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: context.appColors.textMuted),
                  onPressed: () => onChanged(null),
                  tooltip: 'Clear',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isWhite = color.toARGB32() == 0xFFFFFFFF;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? AppColors.navy
                : isWhite
                    ? AppColors.cardBorder
                    : Colors.transparent,
            width: selected ? 2.5 : 1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.25),
                blurRadius: 0,
                spreadRadius: 2,
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: selected
            ? Icon(
                Icons.check,
                size: 18,
                color: isWhite || color.computeLuminance() > 0.55
                    ? AppColors.navy
                    : Colors.white,
              )
            : null,
      ),
    );
  }
}
