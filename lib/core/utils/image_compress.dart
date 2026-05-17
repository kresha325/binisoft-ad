import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Resize/compress before upload (web callable limit + faster uploads).
Future<({Uint8List bytes, String fileName, String contentType})> compressForUpload(
  Uint8List input,
  String fileName, {
  int maxWidth = 1200,
  int maxBytes = 900000,
}) async {
  final decoded = img.decodeImage(input);
  if (decoded == null) {
    return (bytes: input, fileName: fileName, contentType: _mimeFromName(fileName));
  }

  var image = decoded;
  if (image.width > maxWidth) {
    image = img.copyResize(image, width: maxWidth);
  }

  var quality = 85;
  var bytes = Uint8List.fromList(img.encodeJpg(image, quality: quality));
  while (bytes.length > maxBytes && quality > 45) {
    quality -= 10;
    bytes = Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }

  final outName = fileName.contains('.')
      ? '${fileName.substring(0, fileName.lastIndexOf('.'))}.jpg'
      : '$fileName.jpg';

  return (bytes: bytes, fileName: outName, contentType: 'image/jpeg');
}

String _mimeFromName(String fileName) {
  final lower = fileName.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.gif')) return 'image/gif';
  return 'image/jpeg';
}
