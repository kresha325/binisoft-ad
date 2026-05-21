import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/entities/job_opening.dart';
import '../providers/job_openings_providers.dart';

Future<void> showJobApplicationsSheet(
  BuildContext context,
  WidgetRef ref, {
  required JobOpening opening,
}) {
  return showAppSideSheet<void>(
    context: context,
    title: context.l10n.jobApplicationsTitle(opening.title),
    showFooter: false,
    child: Consumer(
      builder: (context, ref, _) {
        final l10n = context.l10n;
        final colors = context.appColors;
        final apps = ref.watch(jobApplicationsProvider(opening.id));

        return apps.when(
          loading: () => const SizedBox(height: 200, child: LoadingOverlay()),
          error: (e, _) => Text(
            l10n.errorGeneric('$e'),
            style: TextStyle(color: colors.danger),
          ),
          data: (items) {
            if (items.isEmpty) {
              return Text(
                l10n.jobApplicationsEmpty,
                style: GoogleFonts.inter(color: colors.textMuted),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final a = items[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    a.name,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.phone, style: GoogleFonts.inter(fontSize: 13)),
                      if (a.email != null && a.email!.isNotEmpty)
                        Text(a.email!, style: GoogleFonts.inter(fontSize: 13)),
                      if (a.note != null && a.note!.isNotEmpty)
                        Text(a.note!, style: GoogleFonts.inter(fontSize: 12)),
                      Text(
                        DateFormat('d MMM yyyy, HH:mm').format(a.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ),
  );
}
