DateTime appointmentDateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool appointmentIsSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
