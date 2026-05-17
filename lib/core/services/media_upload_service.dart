import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../utils/image_compress.dart';
import '../utils/platform_file_bytes.dart';
import 'storage_url_resolver.dart';

class MediaUploadService {
  MediaUploadService({FirebaseStorage? storage, StorageUrlResolver? urlResolver})
      : _storage = storage ?? FirebaseStorage.instance,
        _urlResolver = urlResolver ??
            StorageUrlResolver(storage: storage ?? FirebaseStorage.instance);

  static const _functionsBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net';

  final FirebaseStorage _storage;
  final StorageUrlResolver _urlResolver;

  Future<String> resolveImageUrl(String url) => _urlResolver.resolve(url);

  Future<void> _ensureAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseException(
        plugin: 'firebase_auth',
        code: 'unauthenticated',
        message: 'You must be signed in to upload files',
      );
    }
    await user.getIdToken(true);
  }

  /// HTTP upload (CORS-enabled) — used on Flutter web.
  Future<String> _uploadViaHttp({
    required String endpoint,
    required Map<String, dynamic> payload,
  }) async {
    await _ensureAuthenticated();
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();

    if (kDebugMode) {
      debugPrint('HTTP upload: $endpoint (${payload['fileName']})');
    }

    final response = await http.post(
      Uri.parse('$_functionsBaseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      String message = 'Upload failed (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final err = body['error'] as Map<String, dynamic>?;
        message = err?['message'] as String? ?? message;
      } catch (_) {}
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'upload-failed',
        message: message,
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final url = data['downloadUrl'] as String?;
    if (url == null || url.isEmpty) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'invalid-url',
        message: 'Upload failed: no download URL returned',
      );
    }
    return url;
  }

  Future<String> uploadBytes({
    required String storagePath,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await _ensureAuthenticated();

    if (bytes.isEmpty) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'invalid-argument',
        message: 'Image file is empty',
      );
    }

    final compressed = await compressForUpload(bytes, fileName);

    if (kIsWeb) {
      if (storagePath.contains('/products/')) {
        final parts = storagePath.split('/products/');
        if (parts.length == 2) {
          final productId = parts[1].split('/').first;
          final businessId = parts[0].replaceFirst('businesses/', '');
          return _uploadViaHttp(
            endpoint: 'uploadProductImageHttp',
            payload: {
              'businessId': businessId,
              'productId': productId,
              'fileName': compressed.fileName,
              'contentType': compressed.contentType,
              'base64': base64Encode(compressed.bytes),
            },
          );
        }
      }
      if (storagePath.contains('/logo/')) {
        final businessId = storagePath.split('/')[1];
        return _uploadViaHttp(
          endpoint: 'uploadBusinessLogoHttp',
          payload: {
            'businessId': businessId,
            'fileName': compressed.fileName,
            'contentType': compressed.contentType,
            'base64': base64Encode(compressed.bytes),
          },
        );
      }
    }

    final ref = _storage.ref(storagePath);
    if (kDebugMode) {
      debugPrint(
        'Storage upload: $storagePath (${compressed.contentType}, ${compressed.bytes.length} bytes)',
      );
    }

    await ref.putData(
      compressed.bytes,
      SettableMetadata(
        contentType: compressed.contentType,
        customMetadata: {'originalFileName': compressed.fileName},
      ),
    );

    return ref.getDownloadURL();
  }

  Future<String> uploadPlatformFile({
    required String storagePath,
    required PlatformFile file,
  }) async {
    final bytes = await readPlatformFileBytes(file);
    return uploadBytes(storagePath: storagePath, bytes: bytes, fileName: file.name);
  }

  Future<String> uploadProductImage({
    required String businessId,
    required String productId,
    required PlatformFile file,
  }) async {
    if (kIsWeb) {
      final bytes = await readPlatformFileBytes(file);
      final compressed = await compressForUpload(bytes, file.name);
      return _uploadViaHttp(
        endpoint: 'uploadProductImageHttp',
        payload: {
          'businessId': businessId,
          'productId': productId,
          'fileName': compressed.fileName,
          'contentType': compressed.contentType,
          'base64': base64Encode(compressed.bytes),
        },
      );
    }

    final path =
        '${StoragePaths.productMedia(businessId, productId)}/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    return uploadPlatformFile(storagePath: path, file: file);
  }

  Future<String> uploadBusinessLogo({
    required String businessId,
    required PlatformFile file,
  }) async {
    if (kIsWeb) {
      final bytes = await readPlatformFileBytes(file);
      final compressed = await compressForUpload(bytes, file.name);
      return _uploadViaHttp(
        endpoint: 'uploadBusinessLogoHttp',
        payload: {
          'businessId': businessId,
          'fileName': compressed.fileName,
          'contentType': compressed.contentType,
          'base64': base64Encode(compressed.bytes),
        },
      );
    }

    final path =
        '${StoragePaths.businessRoot(businessId)}/logo/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    return uploadPlatformFile(storagePath: path, file: file);
  }

  Future<String> uploadDashboardBackground({
    required String businessId,
    required PlatformFile file,
  }) async {
    if (kIsWeb) {
      final bytes = await readPlatformFileBytes(file);
      final compressed = await compressForUpload(bytes, file.name);
      return _uploadViaHttp(
        endpoint: 'uploadBusinessBackgroundHttp',
        payload: {
          'businessId': businessId,
          'fileName': compressed.fileName,
          'contentType': compressed.contentType,
          'base64': base64Encode(compressed.bytes),
        },
      );
    }

    final path =
        '${StoragePaths.businessRoot(businessId)}/background/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    return uploadPlatformFile(storagePath: path, file: file);
  }
}
