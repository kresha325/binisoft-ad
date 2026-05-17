import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'page_header.dart';

/// Standard admin page: business logo + title row, then page content.
class AdminPageLayout extends ConsumerWidget {
  const AdminPageLayout({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.action,
    this.scrollable = true,
    this.paddingAfterHeader = 24,
    this.showHeader = true,
  });

  final String? title;
  final String? subtitle;
  final bool showHeader;
  final Widget child;
  final Widget? action;
  final bool scrollable;
  final double paddingAfterHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final header = showHeader && title != null && subtitle != null
        ? PageHeader(
            title: title!,
            subtitle: subtitle!,
            action: action,
          )
        : null;

    if (scrollable) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) ...[
              header,
              SizedBox(height: paddingAfterHeader),
            ],
            child,
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) ...[
          header,
          SizedBox(height: paddingAfterHeader),
        ],
        Expanded(child: child),
      ],
    );
  }
}
