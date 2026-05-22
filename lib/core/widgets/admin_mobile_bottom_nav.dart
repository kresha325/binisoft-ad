import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/permissions_providers.dart';
import '../l10n/l10n_extension.dart';
import '../theme/app_color_scheme.dart';

/// Primary navigation on phones — complements the drawer for secondary routes.
class AdminMobileBottomNav extends ConsumerWidget {
  const AdminMobileBottomNav({
    super.key,
    required this.location,
    required this.onNavigate,
    required this.onOpenMenu,
  });

  final String location;
  final ValueChanged<String> onNavigate;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final perms = ref.watch(businessPermissionsProvider);

    final items = <_MobileNavItem>[];
    if (perms.canManageOrders) {
      items.add(_MobileNavItem('/dashboard', l10n.navDashboard, Icons.grid_view_rounded));
      items.add(_MobileNavItem('/orders', l10n.navOrders, Icons.shopping_bag_outlined));
    }
    if (perms.canWriteCatalog || perms.canAccessRoute('/products')) {
      items.add(_MobileNavItem('/products', l10n.navProducts, Icons.inventory_2_outlined));
    }
    if (perms.canAccessSettings) {
      items.add(_MobileNavItem('/settings', l10n.navSettings, Icons.settings_outlined));
    }
    items.add(_MobileNavItem('__menu__', l10n.navMenu, Icons.menu_rounded));

    if (items.length < 2) return const SizedBox.shrink();

    var selected = -1;
    for (var i = 0; i < items.length; i++) {
      final path = items[i].path;
      if (path == '__menu__') continue;
      if (location == path ||
          (path != '/dashboard' && location.startsWith('$path/'))) {
        selected = i;
        break;
      }
    }
    if (selected < 0) {
      selected = items.indexWhere((e) => e.path == '/settings');
      if (selected < 0) selected = 0;
    }

    return Material(
      elevation: 8,
      color: colors.surface,
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: selected.clamp(0, items.length - 1),
          height: 64,
          backgroundColor: colors.surface,
          indicatorColor: colors.accentSoft,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            final item = items[index];
            if (item.path == '__menu__') {
              onOpenMenu();
            } else {
              onNavigate(item.path);
            }
          },
          destinations: [
            for (final item in items)
              NavigationDestination(
                icon: Icon(item.icon, size: 22),
                selectedIcon: Icon(item.icon, color: colors.accent, size: 22),
                label: item.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavItem {
  const _MobileNavItem(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;
}
