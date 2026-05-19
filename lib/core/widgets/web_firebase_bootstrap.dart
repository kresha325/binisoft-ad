import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import '../bootstrap/firebase_web_config.dart';
import '../bootstrap/firebase_web_preload_wait.dart';
import '../constants/app_constants.dart';
import '../utils/client_platform.dart';
import '../utils/open_dashboard_url.dart';
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
  Duration get _initTimeout =>
      isAppleMobileBrowser ? const Duration(seconds: 45) : const Duration(seconds: 15);

  Object? _error;
  var _ready = false;
  var _retrying = false;
  Timer? _watchdog;

  @override
  void initState() {
    super.initState();
    if (!_isCorrectDeployPath()) {
      _error = StateError(
        'Wrong URL. Open:\n${AppConstants.dashboardWebUrl}/#/login',
      );
      return;
    }
    unawaited(_initFirebase());
  }

  bool _isCorrectDeployPath() {
    final uri = Uri.base;
    final host = uri.host.toLowerCase();
    // Local dev (flutter run -d chrome) — always allow Firebase init.
    if (host == 'localhost' || host == '127.0.0.1') {
      return true;
    }
    return uri.path.contains('binisoft-ad');
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    super.dispose();
  }

  void _fail(Object e) {
    _watchdog?.cancel();
    if (!mounted || _ready) return;
    setState(() => _error = e);
  }

  void _armWatchdog() {
    _watchdog?.cancel();
    _watchdog = Timer(_initTimeout, () {
      _fail(
        TimeoutException(
          'Firebase did not respond in ${_initTimeout.inSeconds}s.',
        ),
      );
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
      await awaitFirebaseWebPreload(timeout: _initTimeout);
      await Future.any<void>([
        _initializeFirebase(options),
        Future<void>.delayed(
          _initTimeout,
          () => throw TimeoutException(
            'Firebase timed out (${_initTimeout.inSeconds}s)',
          ),
        ),
      ]);
      _watchdog?.cancel();
      if (mounted) setState(() => _ready = true);
    } catch (e, st) {
      if (kDebugMode) debugPrint('Web Firebase init failed: $e\n$st');
      _fail(e);
    }
  }

  /// Core init first; Firestore settings in a short follow-up (Safari can hang on settings).
  Future<void> _initializeFirebase(FirebaseOptions options) async {
    await Firebase.initializeApp(options: options);
    try {
      await configureFirestoreForWeb().timeout(const Duration(seconds: 8));
    } on TimeoutException {
      if (kDebugMode) {
        debugPrint('Firestore web settings timed out; continuing without long-poll apply.');
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
      return _WebFirebaseLoading(
        onRetry: _retrying ? null : _retry,
        onGiveUp: () => _fail(
          TimeoutException('Connection stalled. Tap Try again or Reload.'),
        ),
      );
    }
    return widget.child;
  }
}

class _WebFirebaseLoading extends StatefulWidget {
  const _WebFirebaseLoading({this.onRetry, this.onGiveUp});

  final VoidCallback? onRetry;
  final VoidCallback? onGiveUp;

  @override
  State<_WebFirebaseLoading> createState() => _WebFirebaseLoadingState();
}

class _WebFirebaseLoadingState extends State<_WebFirebaseLoading> {
  var _seconds = 0;
  Timer? _tick;
  var _gaveUp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => dismissWebBootOverlay());
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
      final stallSeconds = isAppleMobileBrowser ? 50 : 18;
      if (_seconds >= stallSeconds && !_gaveUp && widget.onGiveUp != null) {
        _gaveUp = true;
        widget.onGiveUp!();
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fullUrl = '${AppConstants.dashboardWebUrl}/#/login';
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
                  'Connecting… ($_seconds s)',
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2B56),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF2EC4C6), width: 0.5),
                  ),
                  child: SelectableText(
                    fullUrl,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF2EC4C6),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Wi‑Fi · not Private Browsing\n'
                  '(Do not type * in the address bar)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: openDashboardUrl,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC4C6),
                    foregroundColor: const Color(0xFF0F1A33),
                  ),
                  child: const Text('Open correct address'),
                ),
                if (_seconds >= 6 && widget.onRetry != null) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: widget.onRetry,
                    child: const Text(
                      'Retry connection',
                      style: TextStyle(color: Color(0xFF2EC4C6)),
                    ),
                  ),
                ],
                TextButton(
                  onPressed: reloadPage,
                  child: const Text(
                    'Reload page',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
