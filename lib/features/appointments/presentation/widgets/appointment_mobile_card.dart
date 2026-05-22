import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/entities/appointment.dart';

/// Touch-friendly appointment row for phones (replaces horizontal table scroll).
class AppointmentMobileCard extends StatelessWidget {
  const AppointmentMobileCard({
    super.key,
    required this.appointment,
    required this.onTap,
    this.onMarkCompleted,
    this.onMarkCancelled,
  });

  final Appointment appointment;
  final VoidCallback onTap;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onMarkCancelled;

  static (String label, StatusChipTone tone) statusDisplay(
    BuildContext context,
    Appointment a,
  ) {
    final l10n = context.l10n;
    final displayStatus = a.status == AppointmentStatus.cancelled
        ? AppointmentStatus.cancelled
        : a.countsAsCompleted
            ? AppointmentStatus.completed
            : AppointmentStatus.scheduled;
    final label = switch (displayStatus) {
      AppointmentStatus.scheduled => l10n.appointmentStatusScheduled,
      AppointmentStatus.completed => l10n.appointmentStatusCompleted,
      AppointmentStatus.cancelled => l10n.appointmentStatusCancelled,
    };
    final tone = switch (displayStatus) {
      AppointmentStatus.scheduled => StatusChipTone.accent,
      AppointmentStatus.completed => StatusChipTone.success,
      AppointmentStatus.cancelled => StatusChipTone.neutral,
    };
    return (label, tone);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final a = appointment;
    final timeFmt = DateFormat.Hm();
    final dateFmt = DateFormat('d MMM yyyy');
    final (statusLabel, statusTone) = statusDisplay(context, a);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        child: GlassSurface(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeFmt.format(a.scheduledAt),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          dateFmt.format(a.scheduledAt),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(label: statusLabel, tone: statusTone),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                a.fullName,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              if (a.serviceType.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  a.serviceType,
                  style: GoogleFonts.inter(fontSize: 13, color: colors.accent),
                ),
              ],
              if (a.phoneNumber.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  a.phoneNumber,
                  style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
                ),
              ],
              if (a.description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  a.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: colors.textMuted,
                    height: 1.35,
                  ),
                ),
              ],
              if (a.countsAsScheduled &&
                  (onMarkCompleted != null || onMarkCancelled != null)) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (onMarkCompleted != null)
                      IconButton(
                        tooltip: context.l10n.appointmentMarkCompleted,
                        icon: const Icon(Icons.check_circle_outline),
                        color: colors.success,
                        onPressed: onMarkCompleted,
                      ),
                    if (onMarkCancelled != null)
                      IconButton(
                        tooltip: context.l10n.appointmentMarkCancelled,
                        icon: const Icon(Icons.cancel_outlined),
                        color: colors.danger,
                        onPressed: onMarkCancelled,
                      ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: colors.textMuted),
                  ],
                ),
              ] else
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.chevron_right, color: colors.textMuted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
