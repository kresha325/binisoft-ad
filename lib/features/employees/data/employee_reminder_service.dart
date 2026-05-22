import 'package:intl/intl.dart';

import '../../business/domain/entities/business.dart';
import '../../notifications/data/models/notification_model.dart';
import '../../notifications/data/notification_dispatcher.dart';
import '../../notifications/domain/notification_type.dart';
import '../domain/entities/employee.dart';
import 'employee_payment_schedule.dart';
import 'repositories/employee_repository.dart';

class EmployeeReminderService {
  EmployeeReminderService({
    required EmployeeRepository repository,
    required NotificationDispatcher dispatcher,
  })  : _repository = repository,
        _dispatcher = dispatcher;

  final EmployeeRepository _repository;
  final NotificationDispatcher _dispatcher;

  Future<void> syncReminders({
    required Business business,
    required String currentUserId,
    required List<Employee> employees,
    required String reminderTitle,
    required String Function(String name, String amount, String payDate) reminderBody,
  }) async {
    final now = DateTime.now();
    final recipients = <String>{
      business.ownerId,
      currentUserId,
    };
    final money = NumberFormat.currency(locale: 'sq', symbol: '€');

    for (final employee in employees) {
      if (!employee.active || !employee.hasReminder) continue;
      if (!EmployeePaymentSchedule.shouldSendReminder(
        paymentDayOfMonth: employee.paymentDayOfMonth,
        reminderDaysBefore: employee.reminderDaysBefore,
        reminderSentForMonth: employee.reminderSentForMonth,
        now: now,
      )) {
        continue;
      }

      final payDate = EmployeePaymentSchedule.nextPaymentOnOrAfter(
        employee.paymentDayOfMonth,
        from: now,
      );
      final cycleKey = EmployeePaymentSchedule.monthKey(payDate);

      final claimed = await _repository.tryClaimPaymentReminder(
        businessId: business.id,
        employeeId: employee.id,
        cycleMonthKey: cycleKey,
      );
      if (!claimed) continue;

      final payLabel = DateFormat.yMMMd().format(payDate);
      final body = reminderBody(
        employee.fullName,
        money.format(employee.salary),
        payLabel,
      );

      for (final userId in recipients) {
        if (userId.isEmpty) continue;
        await _dispatcher.notifyUser(
          userId: userId,
          input: CreateNotificationInput(
            type: NotificationType.employeePaymentReminder,
            title: reminderTitle,
            body: body,
            businessId: business.id,
            actionRoute: '/employees',
          ),
        );
      }
    }
  }
}
