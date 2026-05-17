import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/business/presentation/providers/business_providers.dart';
import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_theme.dart';
import 'business_logo_mark.dart';

class PageHeader extends ConsumerWidget {
  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
    this.showBusinessLogo = true,
  });

  final String title;
  final String subtitle;
  final Widget? action;
  final bool showBusinessLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(currentBusinessProvider);

    return businessAsync.when(
      loading: () => _HeaderRow(
        showBusinessLogo: showBusinessLogo,
        businessName: '…',
        logoUrl: null,
        title: title,
        subtitle: subtitle,
        action: action,
      ),
      error: (_, __) => _HeaderRow(
        showBusinessLogo: showBusinessLogo,
        businessName: 'Business',
        logoUrl: null,
        title: title,
        subtitle: subtitle,
        action: action,
      ),
      data: (business) => _HeaderRow(
        showBusinessLogo: showBusinessLogo,
        businessName: business?.name ?? 'Business',
        logoUrl: business?.logoUrl,
        title: title,
        subtitle: subtitle,
        action: action,
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.showBusinessLogo,
    required this.businessName,
    required this.logoUrl,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final bool showBusinessLogo;
  final String businessName;
  final String? logoUrl;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final logoSize = isMobile ? 44.0 : 52.0;
    final titleStyle = AppTextStyles.pageTitle(context).copyWith(
      fontSize: isMobile ? 22 : 30,
    );
    final subtitleStyle = AppTextStyles.pageSubtitle(context).copyWith(
      fontSize: isMobile ? 13 : 16,
      height: 1.35,
    );

    final colors = context.appColors;
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 3,
          decoration: BoxDecoration(
            color: colors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: subtitleStyle,
          maxLines: isMobile ? 2 : 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    final logoRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBusinessLogo) ...[
          BusinessLogoMark(
            businessName: businessName,
            logoUrl: logoUrl,
            size: logoSize,
          ),
          SizedBox(width: isMobile ? 12 : 16),
        ],
        Expanded(child: titleBlock),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          logoRow,
          if (action != null) ...[
            const SizedBox(height: 12),
            action!,
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showBusinessLogo) ...[
          BusinessLogoMark(
            businessName: businessName,
            logoUrl: logoUrl,
            size: logoSize,
          ),
          const SizedBox(width: 16),
        ],
        Expanded(child: titleBlock),
        if (action != null) ...[
          const SizedBox(width: 12),
          action!,
        ],
      ],
    );
  }
}
