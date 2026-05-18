import 'package:flutter/material.dart';

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
                  'iPhone checklist:\n'
                  '• Wi‑Fi (not mobile data only)\n'
                  '• Turn off Private Browsing\n'
                  '• Safari or Chrome — full browser, not in-app link\n'
                  '• Google Cloud: allow https://kresha325.github.io/* on API key\n'
                  '• Firebase Auth: add kresha325.github.io to authorized domains',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.45),
                ),
                const Spacer(),
                if (widget.onRetry != null)
                  FilledButton(
                    onPressed: widget.onRetry,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2EC4C6),
                      foregroundColor: const Color(0xFF0F1A33),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Try again'),
                  ),
                if (widget.onRetry != null) const SizedBox(height: 10),
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
