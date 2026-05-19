import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/page_header_action_provider.dart';

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
  @override
  void initState() {
    super.initState();
    _apply();
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
      ref.read(pageHeaderActionProvider.notifier).state = PageHeaderActionEntry(
        route: widget.route,
        action: widget.action,
      );
    });
  }

  void _clearForRoute(String route) {
    final notifier = ref.read(pageHeaderActionProvider.notifier);
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
