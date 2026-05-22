import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/storage_url_resolver.dart';
import '../theme/app_theme.dart';

/// Loads Firebase Storage images (web uses HTML img to avoid Storage GET CORS).
class StorageNetworkImage extends StatefulWidget {
  const StorageNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  State<StorageNetworkImage> createState() => _StorageNetworkImageState();
}

class _StorageNetworkImageState extends State<StorageNetworkImage> {
  final _resolver = StorageUrlResolver();
  String? _resolvedUrl;
  Uint8List? _bytes;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(StorageNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _resolvedUrl = null;
      _bytes = null;
      _error = null;
      _load();
    }
  }

  Future<void> _load() async {
    if (widget.url.trim().isEmpty) return;

    try {
      final trimmed = widget.url.trim();

      if (StorageUrlResolver.hasDownloadToken(trimmed)) {
        if (mounted) setState(() => _resolvedUrl = trimmed);
        return;
      }

      if (!kIsWeb) {
        final ref = _resolver.refForUrl(trimmed);
        if (ref != null && FirebaseAuth.instance.currentUser != null) {
          try {
            final data = await ref.getData(10 * 1024 * 1024);
            if (data != null && mounted) {
              setState(() {
                _bytes = data;
                _resolvedUrl = null;
              });
              return;
            }
          } catch (_) {}

          final downloadUrl = await ref.getDownloadURL();
          if (mounted) {
            setState(() {
              _resolvedUrl = downloadUrl;
              _bytes = null;
            });
          }
          return;
        }
      }

      final resolved = await _resolver.resolve(trimmed);
      if (mounted) setState(() => _resolvedUrl = resolved);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  /// On web, Flutter's XHR image loader hits Storage CORS; native &lt;img&gt; does not.
  bool _useWebHtmlElement(String url) {
    if (!kIsWeb) return false;
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;
    return StorageUrlResolver.isFirebaseStorageUrl(trimmed) ||
        StorageUrlResolver.hasDownloadToken(trimmed);
  }

  Widget _imageWidget(String url) {
    final useHtml = _useWebHtmlElement(url);
    return Image.network(
      url,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      webHtmlElementStrategy: useHtml
          ? WebHtmlElementStrategy.prefer
          : WebHtmlElementStrategy.never,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_error != null) {
      child = _placeholder();
    } else if (_bytes != null) {
      child = Image.memory(
        _bytes!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } else if (_resolvedUrl != null) {
      child = _imageWidget(_resolvedUrl!);
    } else {
      child = Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.navy.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    if (widget.borderRadius != null) {
      child = ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }

    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: ClipRect(child: child),
      );
    }
    return child;
  }

  Widget _placeholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0xFFF3F4F6),
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 20, color: AppColors.textMuted),
    );
  }
}
