import 'dart:io';

/// Post-build tweaks for GitHub Pages + mobile Safari (especially iPhone).
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

  // Remove empty secondary build entry (can confuse loader on some browsers).
  js = js.replaceAll(',{}]', ']');

  const loadCall = r'''
function binisoftIsAppleMobile() {
  return /iPad|iPhone|iPod/.test(navigator.userAgent) ||
    (navigator.userAgent.includes('Macintosh') && navigator.maxTouchPoints > 1);
}
_flutter.loader.load({
  config: { renderer: 'canvaskit' },
  onEntrypointLoaded: function (engineInitializer) {
    var engineConfig = {
      renderer: 'canvaskit',
      canvasKitMaximumSurfaces: binisoftIsAppleMobile() ? 1 : 2,
    };
    engineInitializer.initializeEngine(engineConfig).then(function (appRunner) {
      return appRunner.runApp();
    }).catch(function (err) {
      console.error('Flutter failed to start', err);
      var hint = document.getElementById('binisoft-boot-hint');
      if (hint) {
        var msg = err && err.message ? err.message : String(err);
        hint.textContent = 'Failed to start: ' + msg;
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
  stdout.writeln('Patched flutter_bootstrap.js (iOS CanvasKit limits, load errors).');
}
