import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../errors/app_exception.dart';

class SiteDeployResult {
  const SiteDeployResult({
    required this.siteUrl,
    required this.deployStatus,
    this.customDomain,
    this.deployError,
    this.dnsRecords = const [],
  });

  final String siteUrl;
  final String deployStatus;
  final String? customDomain;
  final String? deployError;
  final List<SiteDnsRecord> dnsRecords;
}

class SiteDnsRecord {
  const SiteDnsRecord({
    required this.type,
    required this.name,
    required this.value,
    this.note,
  });

  final String type;
  final String name;
  final String value;
  final String? note;

  factory SiteDnsRecord.fromJson(Map<String, dynamic> json) => SiteDnsRecord(
        type: json['type'] as String? ?? 'CNAME',
        name: json['name'] as String? ?? '',
        value: json['value'] as String? ?? '',
        note: json['note'] as String?,
      );
}

class SiteDeployService {
  SiteDeployService({http.Client? client}) : _client = client ?? http.Client();

  static const _functionsBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net';

  final http.Client _client;

  Future<SiteDeployResult> deploySite({
    required String businessId,
    String? customDomain,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const AuthException('Not signed in');
    }
    final token = await user.getIdToken(true);

    final response = await _client.post(
      Uri.parse('$_functionsBaseUrl/deployBusinessSiteHttp'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'businessId': businessId,
        if (customDomain != null && customDomain.trim().isNotEmpty)
          'customDomain': customDomain.trim(),
      }),
    );

    Map<String, dynamic>? body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>?;
    } catch (_) {}

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body?['error'] is Map
          ? (body!['error'] as Map)['message'] as String?
          : body?['message'] as String?;
      throw AuthException(
        message ?? 'Deploy failed (${response.statusCode})',
      );
    }

    final dns = body?['dns'] as Map<String, dynamic>?;
    final recordsRaw = dns?['records'] as List<dynamic>? ?? [];
    final records = recordsRaw
        .whereType<Map>()
        .map((e) => SiteDnsRecord.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return SiteDeployResult(
      siteUrl: body?['siteUrl'] as String? ?? '',
      deployStatus: body?['deployStatus'] as String? ?? 'live',
      customDomain: body?['customDomain'] as String?,
      deployError: body?['deployError'] as String?,
      dnsRecords: records,
    );
  }
}
