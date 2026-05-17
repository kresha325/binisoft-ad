import 'package:flutter/material.dart';

/// App UI languages (admin panel). Default is English.
abstract final class UiLocales {
  static const en = Locale('en');
  static const sq = Locale('sq');
  static const de = Locale('de');

  static const defaultLocale = en;

  static const all = <Locale>[en, sq, de];

  static const codes = <String>['en', 'sq', 'de'];

  static Locale? fromCode(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final code = raw.trim().toLowerCase().split(RegExp(r'[-_]')).first;
    return switch (code) {
      'en' => en,
      'sq' => sq,
      'de' => de,
      _ => null,
    };
  }

  static String codeOf(Locale locale) => locale.languageCode;

  static String menuBadge(Locale locale) => switch (locale.languageCode) {
        'sq' => 'Sq',
        'de' => 'De',
        _ => 'En',
      };
}
