import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/widgets/app_section_card.dart';

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMode = ref.watch(themeModeProvider);
    final mode = resolveThemeMode(asyncMode);
    final l10n = context.l10n;

    return AppSectionCard(
      title: l10n.appearanceTitle,
      subtitle: l10n.appearanceSubtitle,
      icon: Icons.palette_outlined,
      child: SegmentedButton<ThemeMode>(
        segments: [
          ButtonSegment(
            value: ThemeMode.dark,
            label: Text(l10n.themeDark),
            icon: const Icon(Icons.dark_mode_outlined, size: 18),
          ),
          ButtonSegment(
            value: ThemeMode.light,
            label: Text(l10n.themeLight),
            icon: const Icon(Icons.blur_on_outlined, size: 18),
          ),
        ],
        selected: {mode == ThemeMode.light ? ThemeMode.light : ThemeMode.dark},
        onSelectionChanged: (selected) {
          ref.read(themeModeProvider.notifier).setMode(selected.first);
        },
      ),
    );
  }
}
