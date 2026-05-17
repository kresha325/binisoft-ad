import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../storage/theme_preferences_store.dart';

final themePreferencesStoreProvider = Provider<ThemePreferencesStore>(
  (ref) => ThemePreferencesStore(),
);

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final store = ref.watch(themePreferencesStoreProvider);

    ref.listen<AsyncValue<AppUser?>>(authStateProvider, (previous, next) {
      final prevId = previous?.valueOrNull?.id;
      final nextId = next.valueOrNull?.id;
      if (prevId == nextId) return;
      _reloadForUser(store, nextId);
    });

    final userId = ref.watch(authStateProvider).valueOrNull?.id;
    return store.load(userId: userId);
  }

  Future<void> _reloadForUser(ThemePreferencesStore store, String? userId) async {
    final mode = await store.load(userId: userId);
    state = AsyncData(mode);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = AsyncData(mode);
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    await ref.read(themePreferencesStoreProvider).save(userId: userId, mode: mode);
  }
}

/// Resolved theme for [MaterialApp]; falls back to dark while loading.
ThemeMode resolveThemeMode(AsyncValue<ThemeMode> asyncMode) {
  return asyncMode.valueOrNull ?? ThemeMode.dark;
}
