import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui_locales.dart';

class LocalePreferencesStore {
  static const guestKey = 'app_locale_guest';
  static String keyForUser(String uid) => 'app_locale_$uid';

  Future<Locale> load({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey(userId));
    return UiLocales.fromCode(raw) ?? UiLocales.defaultLocale;
  }

  Future<void> save({String? userId, required Locale locale}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey(userId), UiLocales.codeOf(locale));
  }

  String _storageKey(String? userId) {
    final id = userId?.trim();
    if (id == null || id.isEmpty) return guestKey;
    return keyForUser(id);
  }
}
