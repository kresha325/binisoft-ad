import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../errors/app_exception.dart';

/// Auto-translate catalog fields via Cloud Function (Google Translate or demo fallback).
class TranslationService {
  TranslationService({http.Client? client}) : _client = client ?? http.Client();

  static const _functionsBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net';

  final http.Client _client;

  /// Returns per-target-locale field maps: `{ "en": { "name": "...", ... } }`.
  Future<Map<String, Map<String, String>>> translateCatalogFields({
    required String businessId,
    required String sourceLocale,
    required List<String> targetLocales,
    required Map<String, String> fields,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const AuthException('Not signed in');
    }
    final token = await user.getIdToken(true);

    final response = await _client.post(
      Uri.parse('$_functionsBaseUrl/autoTranslateCatalogHttp'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'businessId': businessId,
        'sourceLocale': sourceLocale,
        'targetLocales': targetLocales,
        'fields': fields,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = body['translations'] as Map<String, dynamic>? ?? {};
      return raw.map((locale, value) {
        final map = value as Map<String, dynamic>;
        return MapEntry(
          locale,
          map.map((k, v) => MapEntry(k, v.toString())),
        );
      });
    }

    Map<String, dynamic>? parsed;
    try {
      parsed = jsonDecode(response.body) as Map<String, dynamic>?;
    } catch (_) {}

    final message = parsed?['error'] is Map
        ? (parsed!['error'] as Map)['message'] as String?
        : parsed?['message'] as String?;
    throw AuthException(
      message ?? 'Translation failed (${response.statusCode})',
    );
  }
}
