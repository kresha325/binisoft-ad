import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';

class SuperAdminInvoiceTabs extends StatelessWidget {
  const SuperAdminInvoiceTabs({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
      child: TabBar(
        controller: controller,
        labelColor: colors.accent,
        unselectedLabelColor: colors.textMuted,
        indicatorColor: colors.accent,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Text(
              'Abonimet',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Tab(
            child: Text(
              'Pagesat mujore',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
