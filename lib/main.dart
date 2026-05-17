import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'bootstrap.dart';

void main() {
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  bootstrap(() async {
    runApp(
      const ProviderScope(
        child: BusinessDashboardApp(),
      ),
    );
  });
}
