import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Sends transactional emails via Cloud Function (Firestore `mail` queue).
class EmailDispatchService {
  EmailDispatchService({http.Client? client}) : _client = client ?? http.Client();

  static const _functionsBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net';

  final http.Client _client;

  Future<void> send({
    required String template,
    Map<String, String> variables = const {},
    String? toEmail,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await user.getIdToken();
    final response = await _client.post(
      Uri.parse('$_functionsBaseUrl/sendEmailHttp'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'template': template,
        'variables': variables,
        if (toEmail != null) 'toEmail': toEmail,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) return;
    // Best-effort: do not throw for email failures in UI flows.
  }
}
