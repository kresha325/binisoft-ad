import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import '../theme/app_theme.dart';
import 'auth_scaffold.dart';
import 'brand_logo.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDarkMode;

    return AuthScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 480),
              curve: Curves.easeOutCubic,
              builder: (context, t, child) {
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 14 * (1 - t)),
                    child: child,
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXl + 4),
                  border: Border.all(
                    color: isDark
                        ? colors.cardBorder.withValues(alpha: 0.9)
                        : colors.cardBorder,
                  ),
                  boxShadow: AppShadows.authCard,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDesign.radiusXl + 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accentTeal.withValues(alpha: 0.2),
                              AppColors.accentTeal,
                              AppColors.navy.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 36, 32, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(child: BrandLogo(showTagline: true)),
                            const SizedBox(height: 28),
                            Text(title, style: AppTextStyles.authTitle(context)),
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              style: AppTextStyles.pageSubtitle(context),
                            ),
                            const SizedBox(height: 26),
                            child,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
