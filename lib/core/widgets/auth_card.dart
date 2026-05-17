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

    return AuthScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppDesign.radiusXl),
                border: Border.all(color: colors.cardBorder),
                boxShadow: AppShadows.authCard,
              ),
              padding: const EdgeInsets.fromLTRB(36, 40, 36, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(child: BrandLogo(showTagline: true)),
                  const SizedBox(height: 32),
                  Text(title, style: AppTextStyles.authTitle(context)),
                  const SizedBox(height: 8),
                  Text(subtitle, style: AppTextStyles.pageSubtitle(context)),
                  const SizedBox(height: 28),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
