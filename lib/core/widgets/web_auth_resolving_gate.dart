import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../providers/firebase_providers.dart';

/// Dark loading shell while Firebase Auth / Firestore profile sync on web (avoids white flash).
class WebAuthResolvingGate extends ConsumerWidget {
  const WebAuthResolvingGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsWeb) return child;

    final firebaseUser = ref.watch(authRepositoryProvider).currentFirebaseUser;
    if (firebaseUser == null) return child;

    final authState = ref.watch(authStateProvider);
    if (authState.isLoading || authState.isRefreshing) {
      return _loading();
    }
    if (authState.valueOrNull == null) {
      return _loading();
    }

    return child;
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
