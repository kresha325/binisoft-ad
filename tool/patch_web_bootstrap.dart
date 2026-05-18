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

  const loadCall = '''
_flutter.loader.load({
  config: { renderer: 'canvaskit' },
  onEntrypointLoaded: function (engineInitializer) {
    engineInitializer.initializeEngine().then(function (appRunner) {
      return appRunner.runApp();
    }).catch(function (err) {
      console.error('Flutter failed to start', err);
      var hint = document.getElementById('binisoft-boot-hint');
      if (hint) {
        hint.textContent = 'Failed to start: ' + (err && err.message ? err.message : err);
      }
    });
  }
});
''';

  final loadParen = js.lastIndexOf('_flutter.loader.load(');
  if (loadParen == -1) {
    stderr.writeln('Could not find _flutter.loader.load in flutter_bootstrap.js');
    exit(1);
  }
  js = js.replaceRange(loadParen, js.length, loadCall);

  bootstrap.writeAsStringSync(js);
  stdout.writeln('Patched flutter_bootstrap.js (local CanvasKit, canvaskit renderer, load errors).');
}
