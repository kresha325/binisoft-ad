import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/bootstrap/firebase_web_config.dart';
import 'firebase_options.dart';

Future<void> bootstrap(Future<void> Function() runApp) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Firebase is initialized in [WebFirebaseBootstrap] after the first Flutter frame.
    await runApp();
    return;
  }

  final options = firebaseOptionsWithoutRtdb(DefaultFirebaseOptions.currentPlatform);

  try {
    await Firebase.initializeApp(options: options).timeout(
      const Duration(seconds: 60),
      onTimeout: () => throw TimeoutException('Firebase initialization timed out'),
    );
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('Firebase init failed: $e\n$st');
    }
    rethrow;
  }
  await configureFirestoreForWeb();

  if (kDebugMode) {
    debugPrint('Firebase initialized: ${options.projectId} (web=$kIsWeb)');
  }

  await runApp();
}
