import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../providers/firebase_providers.dart';

/// Notifies [GoRouter] when auth or Firestore profile changes.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    _subs.add(
      ref.watch(authRepositoryProvider).authStateChanges().listen((_) {
        notifyListeners();
      }),
    );
    ref.listen<AsyncValue<dynamic>>(authStateProvider, (_, __) {
      notifyListeners();
    });
  }

  final List<StreamSubscription<dynamic>> _subs = [];

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}

final routerRefreshNotifierProvider = Provider<RouterRefreshNotifier>((ref) {
  final notifier = RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});
