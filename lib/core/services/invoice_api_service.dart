import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../errors/app_exception.dart';

/// Allocates invoice numbers and writes invoices via Cloud Function (Admin SDK).
class InvoiceApiService {
  InvoiceApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _functionsBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net';

  final http.Client _client;

  Future<Map<String, dynamic>> createInvoice(Map<String, dynamic> payload) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const AuthException('Not signed in');
    }

    final token = await user.getIdToken();
    final response = await _client.post(
      Uri.parse('$_functionsBaseUrl/createInvoiceHttp'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final invoice = body['invoice'];
      if (invoice is Map<String, dynamic>) return invoice;
      throw const AuthException('Invalid invoice response');
    }

    Map<String, dynamic>? body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>?;
    } catch (_) {}

    final message = body?['error'] is Map
        ? (body!['error'] as Map)['message'] as String?
        : body?['message'] as String?;
    throw AuthException(
      message ?? 'Create invoice failed (${response.statusCode})',
    );
  }
}
