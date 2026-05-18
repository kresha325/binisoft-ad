import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';

class StaffApiService {
  StaffApiService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Future<String> _idToken() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not signed in');
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) throw Exception('Could not get auth token');
    return token;
  }

  Future<Map<String, dynamic>> inviteStaff({
    required String businessId,
    required String email,
    required String role,
  }) async {
    final token = await _idToken();
    final response = await http.post(
      Uri.parse(CloudFunctionUrls.inviteStaff),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'businessId': businessId,
        'email': email.trim().toLowerCase(),
        'role': role,
      }),
    );
    return _decode(response);
  }

  Future<void> removeStaff({
    required String businessId,
    required String memberUid,
  }) async {
    final token = await _idToken();
    final response = await http.post(
      Uri.parse(CloudFunctionUrls.removeStaff),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'businessId': businessId,
        'memberUid': memberUid,
      }),
    );
    _decode(response);
  }

  Future<Map<String, dynamic>> acceptInvite({
    required String code,
    required String email,
  }) async {
    final token = await _idToken();
    final response = await http.post(
      Uri.parse(CloudFunctionUrls.acceptInvite),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'code': code.trim().toUpperCase(),
        'email': email.trim().toLowerCase(),
      }),
    );
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    final body = response.body.isEmpty ? '{}' : response.body;
    final data = jsonDecode(body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      final err = data['error'];
      final message = err is Map ? err['message']?.toString() : err?.toString();
      throw Exception(message ?? 'Request failed (${response.statusCode})');
    }
    return data;
  }
}
