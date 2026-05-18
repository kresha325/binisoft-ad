import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Strips Realtime Database URL — we use Firestore only. RTDB calls often cause HTTP 400 on web.
FirebaseOptions firebaseOptionsWithoutRtdb(FirebaseOptions source) {
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

Future<void> configureFirestoreForWeb() async {
  if (!kIsWeb) return;
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
}
