import 'package:flutter/foundation.dart' show debugPrint, kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'bootstrap.dart';
import 'core/widgets/web_firebase_bootstrap.dart';
import 'core/widgets/web_init_error_screen.dart';

void main() {
  // Hash URLs (#/dashboard) work reliably on GitHub Pages + mobile Safari (no 404 on refresh).
  if (kIsWeb) {
    GoogleFonts.config.allowRuntimeFetching = true;
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
    final app = kIsWeb
        ? const WebFirebaseBootstrap(child: BusinessDashboardApp())
        : const BusinessDashboardApp();
    runApp(ProviderScope(child: app));
  }).catchError((Object e, StackTrace st) {
    if (!kIsWeb) return;
    debugPrint('bootstrap failed: $e\n$st');
    runApp(
      ProviderScope(
        child: WebInitErrorScreen(message: '$e'),
      ),
    );
  });
}
