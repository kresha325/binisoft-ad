import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  const size = 1024;
  const bg = 0xFF1A2B56; // navy
  const srcPath = 'assets/branding/app_icon.png';
  const outPath = 'assets/branding/app_icon_square.png';

  final bytes = File(srcPath).readAsBytesSync();
  final logo = img.decodePng(bytes);
  if (logo == null) {
    stderr.writeln('Failed to decode $srcPath');
    exit(1);
  }

  final canvas = img.Image(width: size, height: size);
  img.fill(canvas, color: img.ColorRgb8(0x1A, 0x2B, 0x56));

  final maxSide = (size * 0.78).round();
  final scale = maxSide / (logo.width > logo.height ? logo.width : logo.height);
  final nw = (logo.width * scale).round();
  final nh = (logo.height * scale).round();
  final resized = img.copyResize(logo, width: nw, height: nh);
  final x = (size - nw) ~/ 2;
  final y = (size - nh) ~/ 2;
  img.compositeImage(canvas, resized, dstX: x, dstY: y);

  File(outPath).writeAsBytesSync(img.encodePng(canvas));
  stdout.writeln('Wrote $outPath (${nw}x$nh logo on ${size}x$size)');
}
