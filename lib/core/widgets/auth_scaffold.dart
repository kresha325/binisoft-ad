import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_theme.dart';

/// Auth/register backdrop — deep ink mesh with soft teal / navy orbs.
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
                    ? const [
                        Color(0xFF070B14),
                        Color(0xFF0E1628),
                        Color(0xFF121E32),
                      ]
                    : [
                        const Color(0xFFEEF2F8),
                        colors.scaffoldBg,
                        const Color(0xFFE4ECF6),
                      ],
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -80,
            child: _Orb(
              size: 320,
              color: AppColors.accentTeal.withValues(alpha: isDark ? 0.16 : 0.2),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _Orb(
              size: 340,
              color: AppColors.navy.withValues(alpha: isDark ? 0.35 : 0.1),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.35,
            left: MediaQuery.sizeOf(context).width * 0.45,
            child: _Orb(
              size: 160,
              color: AppColors.accentTeal.withValues(alpha: isDark ? 0.06 : 0.08),
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
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
