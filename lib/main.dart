import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'bootstrap.dart';

void main() {
  // Hash URLs (#/dashboard) work reliably on GitHub Pages + mobile Safari (no 404 on refresh).
  if (kIsWeb) {
    setUrlStrategy(HashUrlStrategy());
  }
  bootstrap(() async {
    runApp(
      const ProviderScope(
        child: BusinessDashboardApp(),
      ),
    );
  });
}
