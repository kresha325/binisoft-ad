import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/entities/contest.dart';
import '../providers/contests_providers.dart';

Future<void> showContestEntriesSheet(
  BuildContext context,
  WidgetRef ref, {
  required Contest contest,
}) {
  return showAppSideSheet<void>(
    context: context,
    title: context.l10n.contestEntriesTitle(contest.title),
    showFooter: false,
    child: Consumer(
      builder: (context, ref, _) {
        final l10n = context.l10n;
        final colors = context.appColors;
        final entries = ref.watch(contestEntriesProvider(contest.id));

        return entries.when(
          loading: () => const SizedBox(height: 200, child: LoadingOverlay()),
          error: (e, _) => Text(
            l10n.errorGeneric('$e'),
            style: TextStyle(color: colors.danger),
          ),
          data: (items) {
            if (items.isEmpty) {
              return Text(
                l10n.contestEntriesEmpty,
                style: GoogleFonts.inter(color: colors.textMuted),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final e = items[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    e.name,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.phone, style: GoogleFonts.inter(fontSize: 13)),
                      if (e.email != null && e.email!.isNotEmpty)
                        Text(e.email!, style: GoogleFonts.inter(fontSize: 13)),
                      if (e.note != null && e.note!.isNotEmpty)
                        Text(e.note!, style: GoogleFonts.inter(fontSize: 12)),
                      Text(
                        DateFormat('d MMM yyyy, HH:mm').format(e.createdAt),
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
