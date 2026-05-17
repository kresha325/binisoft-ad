import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_download_links.dart';
import '../utils/client_platform.dart';

/// Opens store / download URLs or in-app web login.
abstract final class AppDownloadService {
  static Future<void> openForPlatform(
    BuildContext context,
    ClientPlatform platform,
  ) async {
    if (platform == ClientPlatform.web) {
      if (context.mounted) context.go(AppDownloadLinks.webAppPath);
      return;
    }

    final url = AppDownloadLinks.urlFor(platform);
    if (url == null || url.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppDownloadLinks.labelFor(platform)} link is not configured yet. '
              'Use the web dashboard or check back soon.',
            ),
          ),
        );
      }
      return;
    }

    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the store link.')),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> openSmartDownload(BuildContext context) async {
    final platform = suggestedDownloadPlatform;
    if (platform == ClientPlatform.unknown) {
      if (context.mounted) {
        await showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (ctx) => _DownloadPickerSheet(
            onPick: (p) {
              Navigator.pop(ctx);
              openForPlatform(context, p);
            },
          ),
        );
      }
      return;
    }
    await openForPlatform(context, platform);
  }
}

class _DownloadPickerSheet extends StatelessWidget {
  const _DownloadPickerSheet({required this.onPick});

  final ValueChanged<ClientPlatform> onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose your platform',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          for (final p in [
            ...landingDownloadPlatforms,
            ClientPlatform.linux,
            ClientPlatform.web,
          ])
            ListTile(
              leading: Icon(_iconFor(p)),
              title: Text(AppDownloadLinks.labelFor(p)),
              subtitle: Text(AppDownloadLinks.subtitleFor(p)),
              onTap: () => onPick(p),
            ),
        ],
      ),
    );
  }

  static IconData _iconFor(ClientPlatform p) => switch (p) {
        ClientPlatform.ios => Icons.apple,
        ClientPlatform.android => Icons.android,
        ClientPlatform.macos => Icons.laptop_mac_rounded,
        ClientPlatform.windows => Icons.desktop_windows_rounded,
        ClientPlatform.linux => Icons.terminal_rounded,
        ClientPlatform.web => Icons.language_rounded,
        ClientPlatform.unknown => Icons.download_rounded,
      };
}
