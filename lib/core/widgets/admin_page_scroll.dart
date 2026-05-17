import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'shell_page_header.dart';

/// One scroll region per admin page: [ShellPageHeader] scrolls off; shell app bar stays fixed.
class AdminPageScroll extends ConsumerWidget {
  const AdminPageScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uri = GoRouterState.of(context).uri;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ShellPageHeader(location: uri.path, uri: uri),
              ),
              SliverToBoxAdapter(child: child),
            ],
          ),
        );
      },
    );
  }
}
