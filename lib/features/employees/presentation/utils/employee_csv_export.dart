import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/employee.dart';

String _csvCell(String value) {
  final v = value.replaceAll('"', '""');
  if (v.contains(',') || v.contains('\n') || v.contains('"')) {
    return '"$v"';
  }
  return v;
}

/// Exports payroll list as CSV (share sheet — no platform email).
Future<void> shareEmployeesCsv({
  required BuildContext context,
  required List<Employee> employees,
  required String businessName,
}) async {
  if (employees.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No employees to export')),
    );
    return;
  }

  final buffer = StringBuffer(
    'firstName,lastName,email,phone,salary,paymentDayOfMonth,reminderDaysBefore,active,showOnSite\n',
  );
  for (final e in employees) {
    buffer.writeln([
      _csvCell(e.firstName),
      _csvCell(e.lastName),
      _csvCell(e.email),
      _csvCell(e.phone),
      e.salary.toStringAsFixed(2),
      '${e.paymentDayOfMonth}',
      '${e.reminderDaysBefore}',
      e.active ? 'yes' : 'no',
      e.showOnSite ? 'yes' : 'no',
    ].join(','));
  }

  final safeName = businessName.replaceAll(RegExp(r'[^\w\-]+'), '_');
  await SharePlus.instance.share(
    ShareParams(
      text: buffer.toString(),
      subject: '${safeName}_employees.csv',
    ),
  );
}
