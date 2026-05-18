import 'package:web/web.dart' as web;

bool _dismissScheduled = false;

/// Tells [web/index.html] to hide the HTML boot splash after the app has painted.
void dismissWebBootOverlay() {
  if (_dismissScheduled) return;
  _dismissScheduled = true;
  // Brief delay so the first Flutter frame is visible before removing the HTML overlay.
  Future<void>.delayed(const Duration(milliseconds: 400), () {
    web.window.dispatchEvent(web.Event('binisoft-ready'));
  });
}
