import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import 'firebase_web_config.dart';

/// Web API key override for local dev (avoids GCP referrer port churn).
///
/// Create a second Browser key with **Application restrictions → None**, then:
/// `flutter run -d chrome --web-port=8080 --dart-define=FIREBASE_WEB_API_KEY=AIza...`
const _webApiKeyOverride = String.fromEnvironment('FIREBASE_WEB_API_KEY');

FirebaseOptions get runtimeFirebaseOptions {
  final base = firebaseOptionsWithoutRtdb(DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb || _webApiKeyOverride.isEmpty) {
    return base;
  }
  return FirebaseOptions(
    apiKey: _webApiKeyOverride,
    appId: base.appId,
    messagingSenderId: base.messagingSenderId,
    projectId: base.projectId,
    authDomain: base.authDomain,
    storageBucket: base.storageBucket,
    measurementId: base.measurementId,
  );
}
