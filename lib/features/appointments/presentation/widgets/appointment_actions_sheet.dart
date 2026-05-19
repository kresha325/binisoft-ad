import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../domain/entities/appointment.dart';
import 'appointment_form_sheet.dart';

Future<void> showAppointmentActionsSheet(
  BuildContext context,
  WidgetRef ref, {
  required Appointment appointment,
  required Future<void> Function(Appointment, AppointmentStatus) onSetStatus,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AppointmentActionsSheet(
      ref: ref,
      appointment: appointment,
      onSetStatus: onSetStatus,
    ),
  );
}

class _AppointmentActionsSheet extends StatelessWidget {
  const _AppointmentActionsSheet({
    required this.ref,
    required this.appointment,
    required this.onSetStatus,
  });

  final WidgetRef ref;
  final Appointment appointment;
  final Future<void> Function(Appointment, AppointmentStatus) onSetStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final timeFmt = DateFormat('d MMM yyyy, HH:mm');

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDesign.radiusXl),
        ),
        border: Border.all(color: colors.cardBorder),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.textMuted.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    appointment.fullName,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${appointment.serviceType} · ${timeFmt.format(appointment.scheduledAt)}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.edit_outlined, color: colors.accent),
              title: Text(l10n.appointmentEditTitle),
              onTap: () {
                Navigator.pop(context);
                showAppointmentFormSheet(
                  context,
                  ref,
                  appointment: appointment,
                );
              },
            ),
            if (appointment.countsAsScheduled) ...[
              ListTile(
                leading: Icon(Icons.check_circle_outline, color: colors.accent),
                title: Text(l10n.appointmentMarkCompleted),
                onTap: () async {
                  Navigator.pop(context);
                  await onSetStatus(appointment, AppointmentStatus.completed);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel_outlined, color: colors.danger),
                title: Text(
                  l10n.appointmentMarkCancelled,
                  style: TextStyle(color: colors.danger),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final ok = await showConfirmDeleteDialog(
                    context,
                    title: l10n.appointmentMarkCancelled,
                    message: appointment.fullName,
                    confirmLabel: l10n.appointmentMarkCancelled,
                  );
                  if (!context.mounted || !ok) return;
                  await onSetStatus(appointment, AppointmentStatus.cancelled);
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
