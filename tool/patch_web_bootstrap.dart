import 'dart:io';

/// Post-build tweaks for GitHub Pages + mobile Safari (especially iPhone).
void main() {
  final bootstrap = File('build/web/flutter_bootstrap.js');
  if (!bootstrap.existsSync()) {
    stderr.writeln('Missing build/web/flutter_bootstrap.js — run flutter build web first.');
    exit(1);
  }

  var js = bootstrap.readAsStringSync();

  // Capture service worker version before stripping (offline-first caching for repeat visits).
  final swMatch = RegExp(r'serviceWorkerVersion:\s*"([^"]+)"').firstMatch(js);
  final swVersion = swMatch?.group(1);

  js = js.replaceAll(
    RegExp(r'serviceWorkerSettings:\s*\{[^}]+\},?'),
    '',
  );

  js = js.replaceAll(',{}]', ']');

  final swVersionLiteral = swVersion != null ? '"$swVersion"' : 'null';

  final loadCall = '''
function binisoftIsAppleMobile() {
  return /iPad|iPhone|iPod/.test(navigator.userAgent) ||
    (navigator.userAgent.includes('Macintosh') && navigator.maxTouchPoints > 1);
}
window.binisoftBootHint = window.binisoftBootHint || function (text, pct) {
  var hint = document.getElementById('binisoft-boot-hint');
  var bar = document.getElementById('binisoft-boot-progress');
  if (hint && text) hint.textContent = text;
  if (bar && typeof pct === 'number') bar.style.width = Math.min(100, pct) + '%';
};
(function () {
  var swVersion = $swVersionLiteral;
  var loadOpts = {
    config: { renderer: 'canvaskit' },
    onEntrypointLoaded: function (engineInitializer) {
      binisoftBootHint('Starting app…', 92);
      var engineConfig = {
        renderer: 'canvaskit',
        canvasKitMaximumSurfaces: binisoftIsAppleMobile() ? 1 : 2,
      };
      if (binisoftIsAppleMobile()) {
        engineConfig.canvasKitForceCpuOnly = true;
      }
      engineInitializer.initializeEngine(engineConfig).then(function (appRunner) {
        binisoftBootHint('Almost ready…', 98);
        return appRunner.runApp();
      }).catch(function (err) {
        console.error('Flutter failed to start', err);
        var msg = err && err.message ? err.message : String(err);
        binisoftBootHint('Failed to start: ' + msg, 0);
      });
    }
  };
  // iOS Safari: offline-first SW can serve stale JS and delay Firebase dynamic import().
  if (!binisoftIsAppleMobile() && swVersion) {
    loadOpts.serviceWorkerSettings = { serviceWorkerVersion: swVersion };
  }
  _flutter.loader.load(loadOpts);
})();
''';

  final loadParen = js.lastIndexOf('_flutter.loader.load(');
  if (loadParen == -1) {
    stderr.writeln('Could not find _flutter.loader.load in flutter_bootstrap.js');
    exit(1);
  }
  js = js.replaceRange(loadParen, js.length, loadCall);

  bootstrap.writeAsStringSync(js);
  stdout.writeln(
    'Patched flutter_bootstrap.js (SW=${swVersion != null}, iOS CanvasKit, progress).',
  );
}
