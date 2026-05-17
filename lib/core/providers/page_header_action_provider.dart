import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Trailing header action registered by a specific route (e.g. `/products`).
class PageHeaderActionEntry {
  const PageHeaderActionEntry({required this.route, required this.action});

  final String route;
  final Widget action;
}

final pageHeaderActionProvider = StateProvider<PageHeaderActionEntry?>((ref) => null);
