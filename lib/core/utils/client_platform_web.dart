import 'dart:html' as html;

import 'client_platform.dart';

ClientPlatform? detectVisitorPlatformFromUserAgent() {
  final ua = html.window.navigator.userAgent.toLowerCase();
  if (ua.contains('iphone') || ua.contains('ipad') || ua.contains('ipod')) {
    return ClientPlatform.ios;
  }
  if (ua.contains('android')) {
    return ClientPlatform.android;
  }
  if (ua.contains('macintosh') || ua.contains('mac os')) {
    return ClientPlatform.macos;
  }
  if (ua.contains('windows')) {
    return ClientPlatform.windows;
  }
  if (ua.contains('linux') && !ua.contains('android')) {
    return ClientPlatform.linux;
  }
  return ClientPlatform.unknown;
}
