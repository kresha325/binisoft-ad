import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../products/presentation/providers/attributes_providers.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../providers/business_providers.dart';
import 'create_business_dialog.dart';

/// Switch active store or create one from the app bar.
class BusinessSwitcher extends ConsumerWidget {
  const BusinessSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final businessesAsync = ref.watch(ownedBusinessesProvider);
    final quotaAsync = ref.watch(businessQuotaProvider);
    final activeId = ref.watch(currentBusinessIdProvider);
    final l10n = context.l10n;

    if (user == null) return const SizedBox.shrink();

    final canCreateMore = quotaAsync.valueOrNull?.canCreateMore ?? true;

    return businessesAsync.when(
      loading: () => const _SwitcherButton(label: '…'),
      error: (_, __) => const SizedBox.shrink(),
      data: (businesses) {
        if (businesses.isEmpty) {
          final colors = context.appColors;
          return OutlinedButton.icon(
            onPressed: () => showCreateBusinessDialog(context, ref),
            icon: const Icon(Icons.add_business_outlined, size: 18),
            label: Text(l10n.switcherCreateStore),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.accent,
              side: BorderSide(color: colors.cardBorder),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }

        final activeBusiness =
            businesses.where((b) => b.id == activeId).firstOrNull;
        final activeName = activeBusiness?.name ?? businesses.first.name;
        final showMenu = businesses.isNotEmpty && (businesses.length > 1 || canCreateMore);

        if (!showMenu && businesses.length == 1) {
          return _SwitcherButton(
            label: activeName,
            showMenuIcon: false,
            leading: Icon(Icons.storefront_outlined, size: 16, color: context.appColors.accent),
          );
        }

        return PopupMenuButton<String>(
          tooltip: l10n.switcherTooltip,
          offset: const Offset(0, 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onSelected: (value) async {
            if (value == '__create__') {
              await showCreateBusinessDialog(context, ref);
              return;
            }
            try {
              await ref.read(authControllerProvider.notifier).switchBusiness(value);
              ref.invalidate(currentBusinessProvider);
              ref.invalidate(ownedBusinessesProvider);
              ref.invalidate(businessQuotaProvider);
              ref.invalidate(productsListProvider);
              ref.invalidate(categoriesListProvider);
              ref.invalidate(attributesListProvider);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$e'), backgroundColor: Colors.red),
                );
              }
            }
          },
          itemBuilder: (context) {
            final colors = context.appColors;
            final quota = quotaAsync.valueOrNull;
            return [
              if (quota != null)
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    l10n.businessesQuotaUsage(quota.owned, quota.max),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              if (quota != null) const PopupMenuDivider(),
              for (final b in businesses)
                PopupMenuItem(
                  value: b.id,
                  child: Row(
                    children: [
                      if (b.id == activeId)
                        Icon(Icons.check_rounded, size: 18, color: colors.accent)
                      else
                        const SizedBox(width: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              b.name,
                              style: GoogleFonts.inter(
                                fontWeight:
                                    b.id == activeId ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            if (b.slug != null && b.slug!.isNotEmpty)
                              Text(
                                b.slug!,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: colors.textMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (canCreateMore) ...[
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: '__create__',
                  child: Row(
                    children: [
                      Icon(Icons.add_business_outlined, size: 20, color: colors.accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.switcherMenuCreateStore(businesses.length, user.maxBusinesses),
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ];
          },
          child: _SwitcherButton(
            label: activeName,
            leading: Icon(Icons.storefront_outlined, size: 16, color: context.appColors.accent),
          ),
        );
      },
    );
  }
}

class _SwitcherButton extends StatelessWidget {
  const _SwitcherButton({
    required this.label,
    this.showMenuIcon = true,
    this.leading,
  });

  final String label;
  final bool showMenuIcon;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: colors.cardBorder),
        borderRadius: BorderRadius.circular(10),
        color: colors.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          if (showMenuIcon) ...[
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 20, color: colors.textMuted),
          ],
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
