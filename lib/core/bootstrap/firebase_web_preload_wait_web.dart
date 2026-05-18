import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

/// Waits for [web/firebase_early.js] (started from index.html before Flutter).
Future<void> awaitFirebaseWebPreload({Duration timeout = const Duration(seconds: 40)}) async {
  final raw = (web.window as JSObject)
      .getProperty('__binisoft_firebase_preload_promise'.toJS);
  if (raw == null || !raw.isA<JSPromise>()) return;

  try {
    await (raw as JSPromise).toDart.timeout(timeout);
  } on TimeoutException {
    // FlutterFire may still inject scripts; continue with initializeApp.
  }
}
