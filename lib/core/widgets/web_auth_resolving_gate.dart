import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../providers/firebase_providers.dart';

/// Dark loading shell while Firebase Auth / Firestore profile sync on web (avoids white flash).
class WebAuthResolvingGate extends ConsumerStatefulWidget {
  const WebAuthResolvingGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<WebAuthResolvingGate> createState() => _WebAuthResolvingGateState();
}

class _WebAuthResolvingGateState extends ConsumerState<WebAuthResolvingGate> {
  static const _maxWait = Duration(seconds: 12);
  Timer? _timer;
  var _timedOut = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_maxWait, () {
      if (mounted) setState(() => _timedOut = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return widget.child;

    final firebaseUser = ref.watch(authRepositoryProvider).currentFirebaseUser;
    if (firebaseUser == null) return widget.child;

    if (_timedOut) return widget.child;

    final authState = ref.watch(authStateProvider);
    if (authState.isLoading || authState.isRefreshing) {
      return _loading();
    }
    if (authState.valueOrNull == null) {
      return _loading();
    }

    return widget.child;
  }

  Widget _loading() {
    return const ColoredBox(
      color: Color(0xFF0F1A33),
      child: Center(
        child: CircularProgressIndicator(color: Color(0xFF2EC4C6)),
      ),
    );
  }
}
