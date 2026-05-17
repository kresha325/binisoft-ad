import 'dart:io';

/// Post-build tweaks for GitHub Pages + mobile Safari.
void main() {
  final bootstrap = File('build/web/flutter_bootstrap.js');
  if (!bootstrap.existsSync()) {
    stderr.writeln('Missing build/web/flutter_bootstrap.js — run flutter build web first.');
    exit(1);
  }

  var js = bootstrap.readAsStringSync();
  js = js.replaceAll(
    RegExp(r'serviceWorkerSettings:\s*\{[^}]+\},?'),
    '',
  );

  const tail = '_flutter.loader.load({';
  final start = js.lastIndexOf(tail);
  if (start != -1 && js.substring(start).contains('Failed to start') == false) {
    js = js.replaceRange(
      start,
      js.length,
      '''
${tail}
  onEntrypointLoaded: function (engineInitializer) {
    engineInitializer.initializeEngine().then(function (appRunner) {
      return appRunner.runApp();
    }).catch(function (err) {
      console.error('Flutter failed to start', err);
      var hint = document.getElementById('binisoft-boot-hint');
      if (hint) hint.textContent = 'Failed to start: ' + (err && err.message ? err.message : err);
    });
  }
});
''',
    );
  }

  bootstrap.writeAsStringSync(js);

  final canvaskit = Directory('build/web/canvaskit');
  if (canvaskit.existsSync()) {
    canvaskit.deleteSync(recursive: true);
    stdout.writeln('Removed build/web/canvaskit (loads from Google CDN).');
  }

  stdout.writeln('Patched flutter_bootstrap.js for mobile.');
}
