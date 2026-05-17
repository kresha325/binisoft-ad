import 'package:firebase_storage/firebase_storage.dart';

/// Turns Storage API URLs into signed download URLs; extracts object paths.
class StorageUrlResolver {
  StorageUrlResolver({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  static bool hasDownloadToken(String url) =>
      url.contains('token=') && url.contains('alt=media');

  static bool isFirebaseStorageUrl(String url) =>
      url.contains('firebasestorage.googleapis.com') ||
      url.contains('firebasestorage.app');

  static String? extractObjectPath(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;

    final nameParam = uri.queryParameters['name'];
    if (nameParam != null && nameParam.isNotEmpty) {
      return Uri.decodeComponent(nameParam);
    }

    final segments = uri.pathSegments;
    final oIndex = segments.indexOf('o');
    if (oIndex >= 0 && oIndex + 1 < segments.length) {
      return Uri.decodeComponent(segments[oIndex + 1]);
    }

    return null;
  }

  Reference? refForUrl(String url) {
    final path = extractObjectPath(url);
    if (path != null) return _storage.ref(path);
    if (url.trim().startsWith('gs://')) {
      return _storage.refFromURL(url.trim());
    }
    return null;
  }

  Future<String> resolve(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;

    if (hasDownloadToken(trimmed)) return trimmed;

    final ref = refForUrl(trimmed);
    if (ref != null) {
      return ref.getDownloadURL();
    }

    if (isFirebaseStorageUrl(trimmed)) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'invalid-url',
        message: 'Could not resolve Firebase Storage URL',
      );
    }

    return trimmed;
  }
}
