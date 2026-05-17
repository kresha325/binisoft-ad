import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_theme.dart';

/// Auth/register backdrop with subtle brand gradient mesh.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDarkMode;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF0A1020),
                        colors.scaffoldBg,
                        const Color(0xFF121E32),
                      ]
                    : [
                        const Color(0xFFEEF2F8),
                        colors.scaffoldBg,
                        const Color(0xFFE8EEF6),
                      ],
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -60,
            child: _Orb(
              size: 220,
              color: AppColors.accentTeal.withValues(alpha: isDark ? 0.12 : 0.18),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -80,
            child: _Orb(
              size: 260,
              color: AppColors.navy.withValues(alpha: isDark ? 0.2 : 0.08),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
