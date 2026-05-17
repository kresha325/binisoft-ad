import 'dart:io';

/// Post-build tweaks for GitHub Pages + mobile Safari.
void main() {
  final bootstrap = File('build/web/flutter_bootstrap.js');
  if (!bootstrap.existsSync()) {
    stderr.writeln('Missing build/web/flutter_bootstrap.js — run flutter build web first.');
    exit(1);
  }

  var js = bootstrap.readAsStringSync();
  // Service worker often leaves mobile Safari on a stale/broken cache.
  js = js.replaceAll(
    RegExp(r'serviceWorkerSettings:\s*\{[^}]+\},?'),
    '',
  );
  bootstrap.writeAsStringSync(js);

  final canvaskit = Directory('build/web/canvaskit');
  if (canvaskit.existsSync()) {
    canvaskit.deleteSync(recursive: true);
    stdout.writeln('Removed build/web/canvaskit (loads from Google CDN).');
  }

  stdout.writeln('Patched flutter_bootstrap.js for mobile.');
}
