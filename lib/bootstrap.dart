import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

/// Strips Realtime Database URL — we use Firestore only. RTDB calls often cause HTTP 400 on web.
FirebaseOptions _optionsWithoutRtdb(FirebaseOptions source) {
  return FirebaseOptions(
    apiKey: source.apiKey,
    appId: source.appId,
    messagingSenderId: source.messagingSenderId,
    projectId: source.projectId,
    authDomain: source.authDomain,
    storageBucket: source.storageBucket,
    iosBundleId: source.iosBundleId,
    androidClientId: source.androidClientId,
    iosClientId: source.iosClientId,
    measurementId: source.measurementId,
  );
}

Future<void> _configureFirestoreForWeb() async {
  if (!kIsWeb) return;
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
}

Future<void> bootstrap(Future<void> Function() runApp) async {
  WidgetsFlutterBinding.ensureInitialized();

  final options = _optionsWithoutRtdb(DefaultFirebaseOptions.currentPlatform);

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
  await _configureFirestoreForWeb();

  if (kDebugMode) {
    debugPrint('Firebase initialized: ${options.projectId} (web=$kIsWeb)');
  }

  await runApp();
}
