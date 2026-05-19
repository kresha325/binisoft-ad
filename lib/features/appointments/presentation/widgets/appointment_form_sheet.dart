import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../../services/presentation/providers/services_providers.dart';
import '../../domain/entities/appointment.dart';
import '../providers/appointment_providers.dart';

const _customServiceKey = '__custom__';

int? reminderMinutesFromChoice(int? choice) {
  if (choice == null || choice <= 0) return null;
  return choice;
}

Future<void> showAppointmentFormSheet(
  BuildContext context,
  WidgetRef ref, {
  Appointment? appointment,
}) async {
  final l10n = context.l10n;
  final isEdit = appointment != null;
  final firstNameController =
      TextEditingController(text: appointment?.firstName ?? '');
  final lastNameController =
      TextEditingController(text: appointment?.lastName ?? '');
  final descriptionController =
      TextEditingController(text: appointment?.description ?? '');
  final serviceTypeController =
      TextEditingController(text: appointment?.serviceType ?? '');
  final phoneController =
      TextEditingController(text: appointment?.phoneNumber ?? '');
  var scheduledAt = appointment?.scheduledAt ??
      DateTime.now().add(const Duration(hours: 1));
  var reminderChoice = appointment?.reminderMinutesBefore ?? 0;
  var saving = false;
  final catalogServices = ref.read(activeServicesListProvider);
  var selectedServiceKey = _customServiceKey;
  if (appointment != null) {
    final match =
        catalogServices.where((s) => s.name == appointment.serviceType);
    if (match.isNotEmpty) {
      selectedServiceKey = match.first.id;
    }
  } else if (catalogServices.isNotEmpty) {
    selectedServiceKey = catalogServices.first.id;
    serviceTypeController.text = catalogServices.first.name;
  }

  await showAppSideSheet<void>(
    context: context,
    title: isEdit ? l10n.appointmentEditTitle : l10n.appointmentAdd,
    showFooter: false,
    child: Consumer(
      builder: (context, ref, _) {
        final services = ref.watch(activeServicesListProvider);
        return StatefulBuilder(
          builder: (context, setState) {
        final colors = context.appColors;
        final dateFmt = DateFormat.yMMMd();
        final timeFmt = DateFormat.Hm();

        Future<void> pickDate() async {
          final picked = await showDatePicker(
            context: context,
            initialDate: scheduledAt,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
          );
          if (picked != null) {
            setState(() {
              scheduledAt = DateTime(
                picked.year,
                picked.month,
                picked.day,
                scheduledAt.hour,
                scheduledAt.minute,
              );
            });
          }
        }

        Future<void> pickTime() async {
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(scheduledAt),
          );
          if (picked != null) {
            setState(() {
              scheduledAt = DateTime(
                scheduledAt.year,
                scheduledAt.month,
                scheduledAt.day,
                picked.hour,
                picked.minute,
              );
            });
          }
        }

        String? validateRequired(String value, String message) {
          if (value.trim().isEmpty) return message;
          return null;
        }

        Future<void> save() async {
          final firstName = firstNameController.text.trim();
          final lastName = lastNameController.text.trim();
          final description = descriptionController.text.trim();
          final phone = phoneController.text.trim();
          final serviceType = selectedServiceKey == _customServiceKey
              ? serviceTypeController.text.trim()
              : services
                  .firstWhere((s) => s.id == selectedServiceKey)
                  .name;

          final error = validateRequired(firstName, l10n.appointmentFirstNameRequired) ??
              validateRequired(lastName, l10n.appointmentLastNameRequired) ??
              validateRequired(description, l10n.appointmentDescriptionRequired) ??
              validateRequired(serviceType, l10n.appointmentServiceTypeRequired) ??
              validateRequired(phone, l10n.appointmentPhoneRequired);

          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
            return;
          }

          setState(() => saving = true);
          try {
            final businessId =
                ref.read(currentBusinessProvider).valueOrNull?.id;
            final uid = ref.read(authStateProvider).valueOrNull?.id;
            if (businessId == null || uid == null) {
              throw Exception('No active business');
            }
            final repo = ref.read(appointmentRepositoryProvider);
            final reminder = reminderMinutesFromChoice(reminderChoice);

            if (isEdit) {
              final changedSchedule = appointment.scheduledAt != scheduledAt;
              final changedReminder =
                  appointment.reminderMinutesBefore != reminder;
              await repo.update(
                businessId: businessId,
                appointment: appointment,
                firstName: firstName,
                lastName: lastName,
                description: description,
                serviceType: serviceType,
                phoneNumber: phone,
                scheduledAt: scheduledAt,
                updateReminder: true,
                reminderMinutesBefore: reminder,
                clearReminderSent: changedSchedule || changedReminder,
                status: appointment.status,
              );
            } else {
              await repo.create(
                businessId: businessId,
                firstName: firstName,
                lastName: lastName,
                description: description,
                serviceType: serviceType,
                phoneNumber: phone,
                scheduledAt: scheduledAt,
                createdBy: uid,
                reminderMinutesBefore: reminder,
              );
            }
            if (!context.mounted) return;
            Navigator.of(context).pop();
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(authErrorMessage(e))),
            );
            setState(() => saving = false);
          }
        }

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: l10n.appointmentFirstName),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: l10n.appointmentLastName),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              if (services.isEmpty)
                TextField(
                  controller: serviceTypeController,
                  decoration: InputDecoration(
                    labelText: l10n.appointmentServiceType,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                )
              else ...[
                DropdownButtonFormField<String>(
                  initialValue: selectedServiceKey,
                  decoration:
                      InputDecoration(labelText: l10n.appointmentServicePick),
                  items: [
                    for (final s in services)
                      DropdownMenuItem(value: s.id, child: Text(s.name)),
                    DropdownMenuItem(
                      value: _customServiceKey,
                      child: Text(l10n.appointmentServiceCustom),
                    ),
                  ],
                  onChanged: saving
                      ? null
                      : (v) {
                          setState(() {
                            selectedServiceKey = v ?? _customServiceKey;
                            if (selectedServiceKey != _customServiceKey) {
                              serviceTypeController.text = services
                                  .firstWhere((s) => s.id == selectedServiceKey)
                                  .name;
                            }
                          });
                        },
                ),
                if (selectedServiceKey == _customServiceKey) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: serviceTypeController,
                    decoration: InputDecoration(
                      labelText: l10n.appointmentServiceType,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ],
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: l10n.appointmentPhone),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\s+\-()]+')),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration:
                    InputDecoration(labelText: l10n.appointmentDescription),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.appointmentScheduledAt,
                style: TextStyle(color: colors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: saving ? null : pickDate,
                      icon: const Icon(Icons.calendar_today_outlined, size: 18),
                      label: Text(dateFmt.format(scheduledAt)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: saving ? null : pickTime,
                      icon: const Icon(Icons.schedule_outlined, size: 18),
                      label: Text(timeFmt.format(scheduledAt)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: reminderChoice,
                decoration:
                    InputDecoration(labelText: l10n.appointmentReminder),
                items: [
                  DropdownMenuItem(
                      value: 0, child: Text(l10n.appointmentReminderNone)),
                  DropdownMenuItem(
                      value: 15, child: Text(l10n.appointmentReminder15)),
                  DropdownMenuItem(
                      value: 30, child: Text(l10n.appointmentReminder30)),
                  DropdownMenuItem(
                      value: 60, child: Text(l10n.appointmentReminder60)),
                  DropdownMenuItem(
                      value: 120, child: Text(l10n.appointmentReminder120)),
                  DropdownMenuItem(
                      value: 1440,
                      child: Text(l10n.appointmentReminder1440)),
                ],
                onChanged: saving
                    ? null
                    : (v) => setState(() => reminderChoice = v ?? 0),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: saving ? null : save,
                child: saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.appointmentSave),
              ),
            ],
        );
          },
        );
      },
    ),
  );

  firstNameController.dispose();
  lastNameController.dispose();
  descriptionController.dispose();
  serviceTypeController.dispose();
  phoneController.dispose();
}
