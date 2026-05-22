import 'dart:async';

import 'package:flutter/foundation.dart';

/// Lightweight error hooks until Crashlytics is wired (mobile release).
void installCrashReporting() {
  if (kDebugMode) return;

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _log('FlutterError', details.exceptionAsString(), details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    _log('async', error.toString(), stack);
    return true;
  };
}

void _log(String kind, String message, StackTrace? stack) {
  // ignore: avoid_print
  print('[Binisoft][$kind] $message');
  if (stack != null) {
    // ignore: avoid_print
    print(stack);
  }
}
