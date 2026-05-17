import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../features/notifications/data/models/notification_model.dart';
import '../errors/app_exception.dart';

/// Sends platform-level notifications to superadmins via Cloud Function (Admin SDK).
class PlatformNotifyService {
  PlatformNotifyService({http.Client? client}) : _client = client ?? http.Client();

  static const _functionsBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net';

  final http.Client _client;

  Future<void> notifySuperadmins(CreateNotificationInput input) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await user.getIdToken();
    final response = await _client.post(
      Uri.parse('$_functionsBaseUrl/platformNotifyHttp'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'type': input.type.value,
        'title': input.title,
        'body': input.body,
        if (input.businessId != null) 'businessId': input.businessId,
        if (input.actionRoute != null) 'actionRoute': input.actionRoute,
      }),
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
      message ?? 'Platform notify failed (${response.statusCode})',
    );
  }
}
