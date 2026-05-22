import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../data/employee_reminder_service.dart';
import '../../data/repositories/employee_repository.dart';
import '../../domain/entities/employee.dart';

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepository(firestore: ref.watch(firestoreProvider));
});

final employeesListProvider = StreamProvider.autoDispose<List<Employee>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  return ref.watch(employeeRepositoryProvider).watchList(businessId: businessId);
});

final employeeReminderServiceProvider = Provider<EmployeeReminderService>((ref) {
  return EmployeeReminderService(
    repository: ref.watch(employeeRepositoryProvider),
    dispatcher: ref.watch(notificationDispatcherProvider),
  );
});
