import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/page_header_action_scope.dart';
import '../widgets/create_business_header_button.dart';
import '../widgets/my_businesses_section.dart';

class BusinessesScreen extends ConsumerWidget {
  const BusinessesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageHeaderActionScope(
      route: '/businesses',
      action: const CreateBusinessHeaderButton(),
      child: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyBusinessesSection(forceVisible: true),
          ],
        ),
      ),
    );
  }
}
