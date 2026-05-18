import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/superadmin_shop_api_tab.dart';

class SuperAdminApiScreen extends StatelessWidget {
  const SuperAdminApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Shop API', style: AppTextStyles.pageTitle(context)),
        const SizedBox(height: 6),
        Text(
          'Public catalog endpoints, API keys, and shop .env for each business.',
          style: AppTextStyles.pageSubtitle(context),
        ),
        const SizedBox(height: 20),
        const Expanded(child: SuperAdminShopApiTab()),
      ],
    );
  }
}
