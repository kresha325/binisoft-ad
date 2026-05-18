import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../errors/app_exception.dart';

/// Calls Cloud Functions that require Firebase Admin (delete users, catalog, businesses).
class SuperAdminService {
  SuperAdminService({http.Client? client}) : _client = client ?? http.Client();

  static const _functionsBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net';

  final http.Client _client;

  Future<void> deleteUserAccount(String targetUid) async {
    await _post(
      'superadminDeleteUserHttp',
      {'targetUid': targetUid},
      errorPrefix: 'Could not delete user',
    );
  }

  Future<void> deleteProduct({
    required String businessId,
    required String productId,
  }) async {
    await _deleteContent(
      kind: 'product',
      businessId: businessId,
      docId: productId,
    );
  }

  Future<void> deleteCategory({
    required String businessId,
    required String categoryId,
  }) async {
    await _deleteContent(
      kind: 'category',
      businessId: businessId,
      docId: categoryId,
    );
  }

  Future<void> deleteOffer({
    required String businessId,
    required String offerId,
  }) async {
    await _deleteContent(
      kind: 'offer',
      businessId: businessId,
      docId: offerId,
    );
  }

  Future<void> deleteBusiness(String businessId) async {
    await _deleteContent(
      kind: 'business',
      businessId: businessId,
    );
  }

  Future<void> _deleteContent({
    required String kind,
    required String businessId,
    String? docId,
  }) async {
    final body = <String, dynamic>{
      'kind': kind,
      'businessId': businessId,
    };
    if (docId != null) body['docId'] = docId;
    await _post(
      'superadminDeleteContentHttp',
      body,
      errorPrefix: 'Could not delete $kind',
    );
  }

  Future<void> _post(
    String functionName,
    Map<String, dynamic> body, {
    required String errorPrefix,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const AuthException('Not signed in');
    }
    final token = await user.getIdToken(true);

    final response = await _client.post(
      Uri.parse('$_functionsBaseUrl/$functionName'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) return;

    Map<String, dynamic>? parsed;
    try {
      parsed = jsonDecode(response.body) as Map<String, dynamic>?;
    } catch (_) {}

    final message = parsed?['error'] is Map
        ? (parsed!['error'] as Map)['message'] as String?
        : parsed?['message'] as String?;
    throw AuthException(
      message ?? '$errorPrefix (${response.statusCode})',
    );
  }
}
