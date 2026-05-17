import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/user_roles.dart';
import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/data_table_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/search_toolbar.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/user_role_badge.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/superadmin_providers.dart';
import '../widgets/superadmin_segment_tabs.dart';

class SuperAdminScreen extends ConsumerStatefulWidget {
  const SuperAdminScreen({super.key});

  @override
  ConsumerState<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends ConsumerState<SuperAdminScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _refreshAll() {
    ref.invalidate(superAdminUsersProvider);
    ref.invalidate(superAdminBusinessesProvider);
    ref.invalidate(superAdminProductsProvider);
  }

  Future<void> _runAction(Future<void> Function() action) async {
    try {
      await action();
      _refreshAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final users = ref.watch(superAdminUsersProvider);
    final businesses = ref.watch(superAdminBusinessesProvider);
    final products = ref.watch(superAdminProductsProvider);

    final userCount = users.valueOrNull?.length;
    final businessCount = businesses.valueOrNull?.length;
    final productCount = products.valueOrNull?.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PlatformHero(
          userCount: userCount,
          businessCount: businessCount,
          productCount: productCount,
          onRefresh: _refreshAll,
        ),
        SizedBox(height: isMobile ? 12 : 20),
        SuperAdminSegmentTabs(
          controller: _tabs,
          labels: const ['Users', 'Businesses', 'Products'],
        ),
        SizedBox(height: isMobile ? 12 : 20),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              _UsersTab(onRefresh: _refreshAll, runAction: _runAction),
              _BusinessesTab(onRefresh: _refreshAll, runAction: _runAction),
              _ProductsTab(onRefresh: _refreshAll, runAction: _runAction),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlatformHero extends StatelessWidget {
  const _PlatformHero({
    required this.userCount,
    required this.businessCount,
    required this.productCount,
    required this.onRefresh,
  });

  final int? userCount;
  final int? businessCount;
  final int? productCount;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = AppBreakpoints.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Platform Console',
                    style: AppTextStyles.pageTitle(context).copyWith(
                      fontSize: isMobile ? 24 : 28,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Manage users, businesses, and catalog data across the platform.',
                    style: AppTextStyles.pageSubtitle(context).copyWith(
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: onRefresh,
              tooltip: 'Refresh all',
              icon: const Icon(Icons.refresh_rounded, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth > AppBreakpoints.tablet
                ? 3
                : isMobile
                    ? 3
                    : constraints.maxWidth > 480
                        ? 2
                        : 1;
            return GridView.count(
              crossAxisCount: cols,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: isMobile ? 2.6 : 2.2,
              children: [
                StatCard(
                  label: 'Users',
                  value: userCount?.toString() ?? '—',
                  icon: Icons.people_outline_rounded,
                ),
                StatCard(
                  label: 'Businesses',
                  value: businessCount?.toString() ?? '—',
                  icon: Icons.storefront_outlined,
                ),
                StatCard(
                  label: 'Products',
                  value: productCount?.toString() ?? '—',
                  icon: Icons.inventory_2_outlined,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _UsersTab extends ConsumerStatefulWidget {
  const _UsersTab({required this.onRefresh, required this.runAction});

  final VoidCallback onRefresh;
  final Future<void> Function(Future<void> Function()) runAction;

  @override
  ConsumerState<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends ConsumerState<_UsersTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final currentUid = ref.watch(authStateProvider).valueOrNull?.id;
    final usersAsync = ref.watch(superAdminUsersProvider);

    return usersAsync.when(
      loading: () => const LoadingOverlay(message: 'Loading users…'),
      error: (e, _) => _ErrorState(message: '$e', onRetry: widget.onRefresh),
      data: (users) {
        final filtered = users.where((u) {
          final q = _query.toLowerCase();
          if (q.isEmpty) return true;
          return u.email.toLowerCase().contains(q) ||
              (u.displayName?.toLowerCase().contains(q) ?? false);
        }).toList();

        return _DataPanel(
          title: '${filtered.length} users',
          onRefresh: widget.onRefresh,
          toolbar: SearchToolbar(
            searchHint: 'Search by email or name…',
            onSearchChanged: (v) => setState(() => _query = v),
          ),
          child: DataTableCard(
            columns: const ['User', 'Role', 'Business', 'Actions'],
            dataRowMaxHeight: 92,
            rows: filtered.map((u) {
              final isSelf = u.id == currentUid;
              return DataRow(cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        u.displayName ?? u.email,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (u.displayName != null)
                        Text(
                          u.email,
                          style: TextStyle(fontSize: 12, color: context.appColors.textMuted),
                        ),
                    ],
                  ),
                ),
                DataCell(UserRoleBadge(role: UserRole.fromString(u.role), compact: true)),
                DataCell(Text(u.businessId.isEmpty ? '—' : u.businessId)),
                DataCell(
                  isSelf
                      ? const StatusChip(label: 'You', tone: StatusChipTone.accent)
                      : _DangerTextButton(
                          label: 'Delete',
                          onPressed: () async {
                            final ok = await showConfirmDeleteDialog(
                              context,
                              title: 'Delete user?',
                              message:
                                  'Permanently delete ${u.email} (Auth + profile). This cannot be undone.',
                            );
                            if (!ok) return;
                            await widget.runAction(
                              () => ref.read(superAdminRepositoryProvider).deleteUser(u.id),
                            );
                          },
                        ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}

class _BusinessesTab extends ConsumerStatefulWidget {
  const _BusinessesTab({required this.onRefresh, required this.runAction});

  final VoidCallback onRefresh;
  final Future<void> Function(Future<void> Function()) runAction;

  @override
  ConsumerState<_BusinessesTab> createState() => _BusinessesTabState();
}

class _BusinessesTabState extends ConsumerState<_BusinessesTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final businessesAsync = ref.watch(superAdminBusinessesProvider);

    return businessesAsync.when(
      loading: () => const LoadingOverlay(message: 'Loading businesses…'),
      error: (e, _) => _ErrorState(message: '$e', onRetry: widget.onRefresh),
      data: (businesses) {
        final filtered = businesses.where((b) {
          final q = _query.toLowerCase();
          if (q.isEmpty) return true;
          return b.name.toLowerCase().contains(q) ||
              (b.slug?.toLowerCase().contains(q) ?? false);
        }).toList();

        return _DataPanel(
          title: '${filtered.length} businesses',
          onRefresh: widget.onRefresh,
          toolbar: SearchToolbar(
            searchHint: 'Search by name or slug…',
            onSearchChanged: (v) => setState(() => _query = v),
          ),
          child: DataTableCard(
            columns: const ['Name', 'Slug', 'Owner', 'Status', 'Actions'],
            rows: filtered.map((b) {
              return DataRow(cells: [
                DataCell(Text(b.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(b.slug ?? '—')),
                DataCell(Text(b.ownerId)),
                DataCell(
                  StatusChip(
                    label: b.active ? 'Active' : 'Inactive',
                    tone: b.active ? StatusChipTone.success : StatusChipTone.danger,
                    icon: b.active ? Icons.check_circle_outline : Icons.pause_circle_outline,
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LinkAction(
                        label: b.active ? 'Deactivate' : 'Activate',
                        onPressed: () async {
                          final label = b.active ? 'deactivate' : 'activate';
                          final ok = await showConfirmDeleteDialog(
                            context,
                            title: '${label[0].toUpperCase()}${label.substring(1)} business?',
                            message:
                                '${b.name} will be ${b.active ? 'hidden from' : 'restored on'} the public API.',
                            confirmLabel: b.active ? 'Deactivate' : 'Activate',
                          );
                          if (!ok) return;
                          await widget.runAction(
                            () => ref.read(superAdminRepositoryProvider).setBusinessActive(
                                  businessId: b.id,
                                  active: !b.active,
                                ),
                          );
                        },
                      ),
                      _DangerTextButton(
                        label: 'Delete',
                        onPressed: () async {
                          final ok = await showConfirmDeleteDialog(
                            context,
                            title: 'Delete business?',
                            message:
                                'Delete ${b.name} and its slug. Subcollections may remain in Firestore.',
                          );
                          if (!ok) return;
                          await widget.runAction(
                            () => ref.read(superAdminRepositoryProvider).deleteBusiness(b.id),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}

class _ProductsTab extends ConsumerStatefulWidget {
  const _ProductsTab({required this.onRefresh, required this.runAction});

  final VoidCallback onRefresh;
  final Future<void> Function(Future<void> Function()) runAction;

  @override
  ConsumerState<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<_ProductsTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(superAdminProductsProvider);

    return productsAsync.when(
      loading: () => const LoadingOverlay(message: 'Loading products…'),
      error: (e, _) => _ErrorState(message: '$e', onRetry: widget.onRefresh),
      data: (products) {
        final filtered = products.where((p) {
          final q = _query.toLowerCase();
          if (q.isEmpty) return true;
          return p.name.toLowerCase().contains(q) ||
              p.businessName.toLowerCase().contains(q);
        }).toList();

        return _DataPanel(
          title: '${filtered.length} products',
          subtitle: 'Latest 500 across all businesses',
          onRefresh: widget.onRefresh,
          toolbar: SearchToolbar(
            searchHint: 'Search product or business…',
            onSearchChanged: (v) => setState(() => _query = v),
          ),
          child: DataTableCard(
            columns: const ['Product', 'Business', 'Status', 'Actions'],
            rows: filtered.map((p) {
              return DataRow(cells: [
                DataCell(Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(p.businessName)),
                DataCell(StatusChip(label: p.status, tone: StatusChipTone.neutral)),
                DataCell(
                  _DangerTextButton(
                    label: 'Delete',
                    onPressed: () async {
                      final ok = await showConfirmDeleteDialog(
                        context,
                        title: 'Delete product?',
                        message: 'Delete "${p.name}" from ${p.businessName}?',
                      );
                      if (!ok) return;
                      await widget.runAction(
                        () => ref.read(superAdminRepositoryProvider).deleteProduct(
                              businessId: p.businessId,
                              productId: p.id,
                            ),
                      );
                    },
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}

class _DataPanel extends StatelessWidget {
  const _DataPanel({
    required this.title,
    required this.onRefresh,
    required this.toolbar,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onRefresh;
  final Widget toolbar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: 'Refresh',
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 12),
        toolbar,
        const SizedBox(height: 16),
        Expanded(child: child),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 40, color: colors.danger),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: colors.textMuted)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _LinkAction extends StatelessWidget {
  const _LinkAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: context.appColors.accent, fontWeight: FontWeight.w600)),
    );
  }
}

class _DangerTextButton extends StatelessWidget {
  const _DangerTextButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: context.appColors.danger, fontWeight: FontWeight.w600)),
    );
  }
}
