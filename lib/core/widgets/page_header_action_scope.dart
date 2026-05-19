import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/page_header_action_provider.dart';
import '../utils/provider_scope_reader.dart';

/// Registers a page header action for [route] (cleared when this scope disposes).
class PageHeaderActionScope extends ConsumerStatefulWidget {
  const PageHeaderActionScope({
    super.key,
    required this.route,
    required this.action,
    required this.child,
  });

  /// GoRouter path, e.g. `/products`.
  final String route;
  final Widget action;
  final Widget child;

  @override
  ConsumerState<PageHeaderActionScope> createState() => _PageHeaderActionScopeState();
}

class _PageHeaderActionScopeState extends ConsumerState<PageHeaderActionScope> {
  ProviderContainer? _providers;

  ProviderContainer _container(BuildContext context) =>
      _providers ??= providerScopeOf(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _apply());
  }

  @override
  void didUpdateWidget(PageHeaderActionScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route != widget.route) {
      _clearForRoute(oldWidget.route);
    }
    _apply();
  }

  void _apply() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final container = _container(context);
      container.read(pageHeaderActionProvider.notifier).state = PageHeaderActionEntry(
        route: widget.route,
        action: widget.action,
      );
    });
  }

  void _clearForRoute(String route) {
    final container = _providers;
    if (container == null) return;
    final notifier = container.read(pageHeaderActionProvider.notifier);
    final current = notifier.state;
    if (current?.route == route) {
      notifier.state = null;
    }
  }

  @override
  void dispose() {
    _clearForRoute(widget.route);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
