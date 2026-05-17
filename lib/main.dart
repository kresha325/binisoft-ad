import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'bootstrap.dart';

void main() {
  bootstrap(() async {
    runApp(
      const ProviderScope(
        child: BusinessDashboardApp(),
      ),
    );
  });
}
