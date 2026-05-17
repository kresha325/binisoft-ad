import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists [ThemeMode] per Firebase user (or guest before sign-in).
class ThemePreferencesStore {
  static const guestKey = 'theme_mode_guest';
  static String keyForUser(String uid) => 'theme_mode_$uid';

  Future<ThemeMode> load({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey(userId));
    return _fromStorage(raw) ?? ThemeMode.dark;
  }

  Future<void> save({String? userId, required ThemeMode mode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey(userId), _toStorage(mode));
  }

  String _storageKey(String? userId) {
    final id = userId?.trim();
    if (id == null || id.isEmpty) return guestKey;
    return keyForUser(id);
  }

  static String _toStorage(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

  static ThemeMode? _fromStorage(String? raw) => switch (raw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.dark, // legacy: system removed, default to dark
        _ => null,
      };
}
