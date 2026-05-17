import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Reads file bytes on web/mobile (stream fallback when [PlatformFile.bytes] is null).
Future<Uint8List> readPlatformFileBytes(PlatformFile file) async {
  if (file.bytes != null && file.bytes!.isNotEmpty) {
    return file.bytes!;
  }

  final stream = file.readStream;
  if (stream != null) {
    final chunks = <int>[];
    await for (final chunk in stream) {
      chunks.addAll(chunk);
    }
    if (chunks.isNotEmpty) return Uint8List.fromList(chunks);
  }

  throw StateError('Could not read image file. Try a smaller image or use Image URL.');
}
