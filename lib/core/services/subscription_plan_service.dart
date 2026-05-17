import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../constants/business_plans.dart';
import '../errors/app_exception.dart';

/// Updates plan limits via Cloud Function (Firestore rules block direct writes).
class SubscriptionPlanService {
  SubscriptionPlanService({http.Client? client}) : _client = client ?? http.Client();

  static const _functionsBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net';

  final http.Client _client;

  Future<void> updatePlan(BusinessPlan plan) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const AuthException('Not signed in');
    }
    final token = await user.getIdToken(true);

    final response = await _client.post(
      Uri.parse('$_functionsBaseUrl/updateSubscriptionPlanHttp'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'maxProducts': plan.maxProducts}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) return;

    Map<String, dynamic>? body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>?;
    } catch (_) {}

    final message = body?['error'] is Map
        ? (body!['error'] as Map)['message'] as String?
        : body?['message'] as String?;
    throw AuthException(
      message ?? 'Could not update plan (${response.statusCode})',
    );
  }
}
