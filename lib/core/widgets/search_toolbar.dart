import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';

class SearchToolbar extends StatelessWidget {
  const SearchToolbar({
    super.key,
    required this.searchHint,
    required this.onSearchChanged,
    this.filter,
  });

  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final Widget? filter;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = AppBreakpoints.isMobile(context);

    final searchField = _SearchField(
      hint: searchHint,
      onChanged: onSearchChanged,
      colors: colors,
    );

    if (!isMobile || filter == null) {
      return Row(
        children: [
          Expanded(flex: 3, child: searchField),
          if (filter != null) ...[
            const SizedBox(width: 12),
            Expanded(flex: 2, child: filter!),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        searchField,
        const SizedBox(height: 10),
        filter!,
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.hint,
    required this.onChanged,
    required this.colors,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.inter(fontSize: 15, color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: colors.textMuted, fontSize: 15),
          prefixIcon: Icon(Icons.search_rounded, size: 20, color: colors.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class FilterDropdown extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final List<DropdownMenuItem<String?>> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textMuted),
          style: GoogleFonts.inter(fontSize: 15, color: colors.textPrimary),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
