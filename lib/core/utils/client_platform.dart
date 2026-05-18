import 'package:flutter/foundation.dart';

import 'client_platform_stub.dart'
    if (dart.library.html) 'client_platform_web.dart' as platform_impl;

/// True when the visitor uses iPhone/iPad Safari or Chrome (WebKit).
bool get isAppleMobileBrowser => platform_impl.isAppleMobileBrowser;

/// Device / OS used for smart download routing.
enum ClientPlatform {
  ios,
  android,
  macos,
  windows,
  linux,
  web,
  unknown,
}

/// Runtime platform when the Flutter app is running.
ClientPlatform get runtimeClientPlatform {
  if (kIsWeb) return ClientPlatform.web;
  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS => ClientPlatform.ios,
    TargetPlatform.android => ClientPlatform.android,
    TargetPlatform.macOS => ClientPlatform.macos,
    TargetPlatform.windows => ClientPlatform.windows,
    TargetPlatform.linux => ClientPlatform.linux,
    _ => ClientPlatform.unknown,
  };
}

/// Best guess for a visitor (web user-agent) or current device (native).
ClientPlatform get suggestedDownloadPlatform {
  final fromAgent = platform_impl.detectVisitorPlatformFromUserAgent();
  if (fromAgent != null && fromAgent != ClientPlatform.unknown) {
    return fromAgent;
  }
  final runtime = runtimeClientPlatform;
  if (runtime != ClientPlatform.web && runtime != ClientPlatform.unknown) {
    return runtime;
  }
  return ClientPlatform.unknown;
}

/// Platforms shown on the landing download grid.
const landingDownloadPlatforms = [
  ClientPlatform.ios,
  ClientPlatform.android,
  ClientPlatform.macos,
  ClientPlatform.windows,
];
