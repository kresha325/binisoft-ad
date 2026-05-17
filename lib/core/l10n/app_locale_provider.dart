import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import 'locale_preferences_store.dart';
import 'ui_locales.dart';

final localePreferencesStoreProvider = Provider<LocalePreferencesStore>(
  (ref) => LocalePreferencesStore(),
);

final appLocaleProvider =
    AsyncNotifierProvider<AppLocaleNotifier, Locale>(AppLocaleNotifier.new);

class AppLocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final store = ref.watch(localePreferencesStoreProvider);

    ref.listen<AsyncValue<AppUser?>>(authStateProvider, (previous, next) {
      final prevId = previous?.valueOrNull?.id;
      final nextId = next.valueOrNull?.id;
      if (prevId == nextId) return;
      _reloadForUser(store, nextId);
    });

    final userId = ref.watch(authStateProvider).valueOrNull?.id;
    return store.load(userId: userId);
  }

  Future<void> _reloadForUser(LocalePreferencesStore store, String? userId) async {
    final locale = await store.load(userId: userId);
    state = AsyncData(locale);
  }

  Future<void> setLocale(Locale locale) async {
    if (!UiLocales.all.contains(locale)) return;
    state = AsyncData(locale);
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    await ref.read(localePreferencesStoreProvider).save(userId: userId, locale: locale);
  }
}

Locale resolveAppLocale(AsyncValue<Locale> asyncLocale) {
  return asyncLocale.valueOrNull ?? UiLocales.defaultLocale;
}
