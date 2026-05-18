import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import '../bootstrap/firebase_web_config.dart';
import '../utils/page_reload.dart';
import '../utils/web_boot_overlay.dart';
import 'web_init_error_screen.dart';

/// On web: start Flutter UI first, then init Firebase (Safari/iPhone can hang on IndexedDB).
class WebFirebaseBootstrap extends StatefulWidget {
  const WebFirebaseBootstrap({super.key, required this.child});

  final Widget child;

  @override
  State<WebFirebaseBootstrap> createState() => _WebFirebaseBootstrapState();
}

class _WebFirebaseBootstrapState extends State<WebFirebaseBootstrap> {
  static const _initTimeout = Duration(seconds: 12);

  Object? _error;
  var _ready = false;
  var _retrying = false;
  Timer? _watchdog;

  @override
  void initState() {
    super.initState();
    unawaited(_initFirebase());
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    super.dispose();
  }

  void _armWatchdog() {
    _watchdog?.cancel();
    _watchdog = Timer(_initTimeout, () {
      if (!mounted || _ready || _error != null) return;
      setState(() {
        _error = TimeoutException(
          'Firebase did not respond in ${_initTimeout.inSeconds}s. '
          'Check Wi‑Fi and Safari settings (disable Private Browsing).',
        );
      });
    });
  }

  Future<void> _initFirebase() async {
    if (Firebase.apps.isNotEmpty) {
      if (mounted) setState(() => _ready = true);
      return;
    }

    _armWatchdog();
    final options = firebaseOptionsWithoutRtdb(DefaultFirebaseOptions.currentPlatform);

    try {
      await Future.any<void>([
        _initializeFirebase(options),
        Future<void>.delayed(
          _initTimeout,
          () => throw TimeoutException(
            'Firebase initialization timed out (${_initTimeout.inSeconds}s)',
          ),
        ),
      ]);
      _watchdog?.cancel();
      if (mounted) setState(() => _ready = true);
    } catch (e) {
      _watchdog?.cancel();
      if (kDebugMode) debugPrint('Web Firebase init failed: $e');
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _initializeFirebase(FirebaseOptions options) async {
    await Firebase.initializeApp(options: options);
    await configureFirestoreForWeb();
    if (kIsWeb) {
      try {
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      } catch (_) {
        await FirebaseAuth.instance.setPersistence(Persistence.NONE);
      }
    }
  }

  Future<void> _retry() async {
    setState(() {
      _error = null;
      _ready = false;
      _retrying = true;
    });
    await _initFirebase();
    if (mounted) setState(() => _retrying = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return WebInitErrorScreen(
        message: '$_error',
        onRetry: _retrying ? null : _retry,
      );
    }
    if (!_ready) {
      return _WebFirebaseLoading(onRetry: _retrying ? null : _retry);
    }
    return widget.child;
  }
}

class _WebFirebaseLoading extends StatefulWidget {
  const _WebFirebaseLoading({this.onRetry});

  final VoidCallback? onRetry;

  @override
  State<_WebFirebaseLoading> createState() => _WebFirebaseLoadingState();
}

class _WebFirebaseLoadingState extends State<_WebFirebaseLoading> {
  var _seconds = 0;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => dismissWebBootOverlay());
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0F1A33),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF2EC4C6)),
                const SizedBox(height: 20),
                Text(
                  _seconds < 12
                      ? 'Connecting… ($_seconds s)'
                      : 'Still connecting… ($_seconds s)',
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 12),
                const Text(
                  'iPhone: use Wi‑Fi, not Private Browsing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                if (_seconds >= 8 && widget.onRetry != null) ...[
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: widget.onRetry,
                    child: const Text(
                      'Retry connection',
                      style: TextStyle(color: Color(0xFF2EC4C6)),
                    ),
                  ),
                ],
                if (_seconds >= 10) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: reloadPage,
                    child: const Text(
                      'Reload page',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
