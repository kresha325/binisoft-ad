import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../products/presentation/providers/attributes_providers.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../providers/business_providers.dart';
import 'create_business_dialog.dart';

/// List owned businesses + create new (up to plan limit: 10 or 100).
class MyBusinessesSection extends ConsumerWidget {
  const MyBusinessesSection({super.key, this.forceVisible = false});

  final bool forceVisible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final businessesAsync = ref.watch(ownedBusinessesProvider);
    final quotaAsync = ref.watch(businessQuotaProvider);
    final activeId = ref.watch(currentBusinessIdProvider);
    final colors = context.appColors;

    if (user == null) return const SizedBox.shrink();

    final plan = BusinessPlan.fromMaxProducts(user.maxProducts);
    final needsFirstBusiness = ref.watch(currentBusinessIdProvider) == null;

    if (!forceVisible && !needsFirstBusiness) {
      final quota = quotaAsync.valueOrNull;
      if (quota != null && !quota.canCreateMore && quota.owned <= 1) {
        return const SizedBox.shrink();
      }
    }

    return AppSectionCard(
      title: forceVisible ? 'Your businesses' : 'My businesses',
      subtitle:
          'Your ${plan.title} plan allows up to ${user.maxBusinesses} businesses. '
          'Each gets its own products, categories, custom fields, and public API.',
      icon: Icons.business_center_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          quotaAsync.when(
            loading: () => const LinearProgressIndicator(minHeight: 6),
            error: (_, __) => const SizedBox.shrink(),
            data: (quota) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      quota.label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.accent,
                      ),
                    ),
                    if (quota.canCreateMore)
                      TextButton.icon(
                        onPressed: () => showCreateBusinessDialog(context, ref),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text('New business (${quota.owned + 1}/${quota.max})'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                  child: LinearProgressIndicator(
                    value: quota.max > 0 ? quota.owned / quota.max : 0,
                    minHeight: 8,
                    backgroundColor: colors.cardBorder,
                    color: colors.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          businessesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e', style: TextStyle(color: colors.danger)),
            data: (businesses) => Column(
              children: [
                for (var i = 0; i < businesses.length; i++) ...[
                  _BusinessTile(
                    name: businesses[i].name,
                    slug: businesses[i].slug ?? '—',
                    isActive: businesses[i].id == activeId,
                    onSwitch: () async {
                      if (businesses[i].id == activeId) return;
                      await ref
                          .read(authControllerProvider.notifier)
                          .switchBusiness(businesses[i].id);
                      ref.invalidate(currentBusinessProvider);
                      ref.invalidate(productsListProvider);
                      ref.invalidate(categoriesListProvider);
                      ref.invalidate(attributesListProvider);
                    },
                  ),
                  if (i < businesses.length - 1) const SizedBox(height: 8),
                ],
                if (businesses.isEmpty)
                  Text(
                    'No businesses yet. Create your first one below.',
                    style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          quotaAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (quota) {
              if (!quota.canCreateMore) {
                return AppInfoBanner(
                  icon: Icons.info_outline_rounded,
                  message:
                      'You reached the limit of ${quota.max} businesses on ${plan.code}.',
                );
              }
              return SizedBox(
                height: 48,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showCreateBusinessDialog(context, ref),
                  icon: const Icon(Icons.add_business_outlined),
                  label: Text('Create new business (${quota.owned}/${quota.max})'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BusinessTile extends StatelessWidget {
  const _BusinessTile({
    required this.name,
    required this.slug,
    required this.isActive,
    required this.onSwitch,
  });

  final String name;
  final String slug;
  final bool isActive;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? colors.accentSoft : colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(
          color: isActive ? colors.accent.withValues(alpha: 0.45) : colors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'API slug: $slug',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            const StatusChip(label: 'Active', tone: StatusChipTone.success, icon: Icons.check_rounded)
          else
            TextButton(
              onPressed: onSwitch,
              child: const Text('Switch'),
            ),
        ],
      ),
    );
  }
}
