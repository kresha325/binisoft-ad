import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'bootstrap.dart';

void main() {
  // Hash URLs (#/dashboard) work reliably on GitHub Pages + mobile Safari (no 404 on refresh).
  if (kIsWeb) {
    // Avoid blocking first paint on fonts.gstatic.com (common on mobile Safari).
    GoogleFonts.config.allowRuntimeFetching = false;
    if (kReleaseMode) {
      ErrorWidget.builder = (details) => Material(
            color: const Color(0xFF0F1A33),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Something went wrong.\n${details.exceptionAsString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
          );
    }
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
