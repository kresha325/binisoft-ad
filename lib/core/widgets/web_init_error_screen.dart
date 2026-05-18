import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../utils/open_dashboard_url.dart';
import '../utils/page_reload.dart';
import '../utils/web_boot_overlay.dart';

/// Shown on web when Firebase fails to initialize (API key, network, timeout).
class WebInitErrorScreen extends StatefulWidget {
  const WebInitErrorScreen({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  State<WebInitErrorScreen> createState() => _WebInitErrorScreenState();
}

class _WebInitErrorScreenState extends State<WebInitErrorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => dismissWebBootOverlay());
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.message ?? 'Unknown error';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0F1A33),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Text(
                  'Could not connect',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  detail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Open in browser (no * in address bar):',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  '${AppConstants.dashboardWebUrl}/',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF2EC4C6), fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Firebase setup (Google Cloud, not Chrome):\n'
                  '• API key referrers: https://kresha325.github.io/*\n'
                  '• Auth domain: kresha325.github.io\n'
                  '• Wi‑Fi, no Private Browsing',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.45),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: openDashboardUrl,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC4C6),
                    foregroundColor: const Color(0xFF0F1A33),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Open correct address'),
                ),
                if (widget.onRetry != null) ...[
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: widget.onRetry,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2EC4C6),
                      side: const BorderSide(color: Color(0xFF2EC4C6)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Try again'),
                  ),
                ],
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: reloadPage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2EC4C6),
                    side: const BorderSide(color: Color(0xFF2EC4C6)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Reload page'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
