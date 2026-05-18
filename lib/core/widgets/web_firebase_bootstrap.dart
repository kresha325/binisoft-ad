import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import '../bootstrap/firebase_web_config.dart';
import '../utils/web_boot_overlay.dart';
import 'web_init_error_screen.dart';

/// On web: start Flutter UI first, then init Firebase (Safari/iPhone is slow to compile WASM).
class WebFirebaseBootstrap extends StatefulWidget {
  const WebFirebaseBootstrap({super.key, required this.child});

  final Widget child;

  @override
  State<WebFirebaseBootstrap> createState() => _WebFirebaseBootstrapState();
}

class _WebFirebaseBootstrapState extends State<WebFirebaseBootstrap> {
  Object? _error;
  var _ready = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initFirebase());
  }

  Future<void> _initFirebase() async {
    if (Firebase.apps.isNotEmpty) {
      if (mounted) setState(() => _ready = true);
      return;
    }

    final options = firebaseOptionsWithoutRtdb(DefaultFirebaseOptions.currentPlatform);
    try {
      await Firebase.initializeApp(options: options).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Firebase initialization timed out'),
      );
      await configureFirestoreForWeb();
      if (mounted) setState(() => _ready = true);
    } catch (e) {
      if (kDebugMode) debugPrint('Web Firebase init failed: $e');
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return WebInitErrorScreen(message: '$_error');
    }
    if (!_ready) {
      return const _WebFirebaseLoading();
    }
    return widget.child;
  }
}

class _WebFirebaseLoading extends StatefulWidget {
  const _WebFirebaseLoading();

  @override
  State<_WebFirebaseLoading> createState() => _WebFirebaseLoadingState();
}

class _WebFirebaseLoadingState extends State<_WebFirebaseLoading> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => dismissWebBootOverlay());
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0F1A33),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF2EC4C6)),
              SizedBox(height: 20),
              Text(
                'Connecting…',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
