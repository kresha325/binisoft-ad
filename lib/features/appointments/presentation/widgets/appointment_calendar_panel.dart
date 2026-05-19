import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../domain/appointment_date.dart';

/// Month grid + day picker for filtering reservations by [scheduledAt] date.
class AppointmentCalendarPanel extends StatelessWidget {
  const AppointmentCalendarPanel({
    super.key,
    required this.focusedMonth,
    required this.selectedDay,
    required this.daysWithAppointments,
    required this.onDaySelected,
    required this.onMonthChanged,
    required this.onToday,
  });

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final Set<DateTime> daysWithAppointments;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onMonthChanged;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).toString();
    final monthLabel = DateFormat.yMMMM(locale).format(focusedMonth);
    final selectedLabel = appointmentIsSameDay(selectedDay, DateTime.now())
        ? '${l10n.appointmentCalendarToday} · ${DateFormat.yMMMEd(locale).format(selectedDay)}'
        : DateFormat.yMMMEd(locale).format(selectedDay);

    return GlassSurface(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: onToday,
                child: Text(l10n.appointmentCalendarToday),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                tooltip: l10n.appointmentCalendarPrevMonth,
                onPressed: () => onMonthChanged(
                  DateTime(focusedMonth.year, focusedMonth.month - 1),
                ),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.appointmentCalendarNextMonth,
                onPressed: () => onMonthChanged(
                  DateTime(focusedMonth.year, focusedMonth.month + 1),
                ),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _WeekdayHeader(locale: locale),
          const SizedBox(height: 4),
          _MonthGrid(
            month: focusedMonth,
            selectedDay: selectedDay,
            daysWithAppointments: daysWithAppointments,
            onDaySelected: onDaySelected,
          ),
        ],
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final ref = DateTime(2024, 1, 1); // Monday
    final labels = List.generate(7, (i) {
      final d = ref.add(Duration(days: i));
      return DateFormat.E(locale).format(d).substring(0, 2);
    });

    return Row(
      children: labels
          .map(
            (l) => Expanded(
              child: Text(
                l,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.selectedDay,
    required this.daysWithAppointments,
    required this.onDaySelected,
  });

  final DateTime month;
  final DateTime selectedDay;
  final Set<DateTime> daysWithAppointments;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Monday = 1 … Sunday = 7
    final startPad = (first.weekday - 1) % 7;
    final totalCells = ((startPad + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNum = index - startPad + 1;
        if (dayNum < 1 || dayNum > daysInMonth) {
          return const SizedBox.shrink();
        }
        final date = DateTime(month.year, month.month, dayNum);
        return _DayCell(
          date: date,
          isSelected: appointmentIsSameDay(date, selectedDay),
          isToday: appointmentIsSameDay(date, DateTime.now()),
          hasAppointments: daysWithAppointments.contains(date),
          onTap: () => onDaySelected(date),
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasAppointments,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool hasAppointments;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Color bg = Colors.transparent;
    Color fg = colors.textPrimary;
    Border? border;

    if (isSelected) {
      bg = colors.accent;
      fg = colors.scaffoldBg;
    } else if (isToday) {
      border = Border.all(color: colors.accent, width: 1.5);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusSm),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppDesign.radiusSm),
            border: border,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              if (hasAppointments && !isSelected)
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: colors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
