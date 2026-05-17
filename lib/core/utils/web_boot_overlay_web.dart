import 'package:web/web.dart' as web;

/// Tells [web/index.html] to hide the HTML boot splash after the first screen paints.
void dismissWebBootOverlay() {
  web.window.dispatchEvent(web.Event('binisoft-ready'));
}
