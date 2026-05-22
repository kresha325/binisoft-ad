import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/storage_network_image.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/employee.dart';
import '../providers/employee_providers.dart';

Future<void> showAddEmployeeSheet(BuildContext context, WidgetRef ref) =>
    showEmployeeSheet(context, ref);

Future<void> showEmployeeSheet(
  BuildContext context,
  WidgetRef ref, {
  Employee? employee,
}) async {
  final providers = ProviderScope.containerOf(context, listen: false);
  final l10n = context.l10n;
  final isEdit = employee != null;

  final firstNameController = TextEditingController(text: employee?.firstName ?? '');
  final lastNameController = TextEditingController(text: employee?.lastName ?? '');
  final emailController = TextEditingController(text: employee?.email ?? '');
  final phoneController = TextEditingController(text: employee?.phone ?? '');
  final salaryController = TextEditingController(
    text: employee != null && employee.salary > 0 ? employee.salary.toStringAsFixed(0) : '',
  );
  var photoUrl = employee?.photoUrl ?? '';
  PlatformFile? photoFile;
  var paymentDay = employee?.paymentDayOfMonth ?? 15;
  var reminderDays = employee?.reminderDaysBefore ?? 1;
  var active = employee?.active ?? true;
  var showOnSite = employee?.showOnSite ?? false;

  final ok = await showAppSideSheet<bool>(
    context: context,
    title: isEdit ? l10n.employeeEditTitle : l10n.employeeAddTitle,
    saveLabel: isEdit ? l10n.saveChanges : l10n.employeeSave,
    child: StatefulBuilder(
      builder: (context, setState) {
        final colors = context.appColors;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: l10n.employeeFirstNameLabel,
              controller: firstNameController,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.employeeLastNameLabel,
              controller: lastNameController,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.employeeEmailLabel,
              controller: emailController,
              hint: l10n.employeeEmailHint,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.employeePhoneLabel,
              controller: phoneController,
              hint: l10n.employeePhoneHint,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.employeeSalaryLabel,
              controller: salaryController,
              hint: l10n.employeeSalaryHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.employeePhotoLabel,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            if (photoUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: StorageNetworkImage(url: photoUrl, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  withData: true,
                );
                if (result == null || result.files.isEmpty) return;
                setState(() {
                  photoFile = result.files.first;
                  photoUrl = '';
                });
              },
              icon: const Icon(Icons.image_outlined, size: 20),
              label: Text(photoFile != null ? photoFile!.name : l10n.employeePickPhoto),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.employeePaymentDayLabel(paymentDay),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: paymentDay.toDouble(),
              min: 1,
              max: 28,
              divisions: 27,
              label: '$paymentDay',
              onChanged: (v) => setState(() => paymentDay = v.round()),
            ),
            DropdownButtonFormField<int>(
              value: reminderDays,
              decoration: InputDecoration(
                labelText: l10n.employeeReminderLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.employeeReminderNone)),
                DropdownMenuItem(value: 1, child: Text(l10n.employeeReminder1Day)),
                DropdownMenuItem(value: 3, child: Text(l10n.employeeReminder3Days)),
                DropdownMenuItem(value: 7, child: Text(l10n.employeeReminder7Days)),
              ],
              onChanged: (v) => setState(() => reminderDays = v ?? 0),
            ),
            const SizedBox(height: 12),
            AppSwitchRow(
              label: l10n.employeeActiveLabel,
              value: active,
              onChanged: (v) => setState(() {
                active = v;
                if (!active) showOnSite = false;
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 8),
              child: Text(
                l10n.employeeActiveHint,
                style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.35),
              ),
            ),
            Opacity(
              opacity: active ? 1 : 0.5,
              child: AppSwitchRow(
                label: l10n.employeeShowOnSiteLabel,
                value: showOnSite,
                onChanged: active ? (v) => setState(() => showOnSite = v) : (_) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                l10n.employeeShowOnSiteHint,
                style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.35),
              ),
            ),
          ],
        );
      },
    ),
  );

  if (ok != true || !context.mounted) return;

  final businessId = providers.read(currentBusinessIdProvider);
  if (businessId == null) return;

  final firstName = firstNameController.text.trim();
  final lastName = lastNameController.text.trim();
  if (firstName.isEmpty || lastName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.employeeNameRequired)),
    );
    return;
  }

  final salary = double.tryParse(salaryController.text.replaceAll(',', '.')) ?? 0;
  if (salary < 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.employeeSalaryInvalid)),
    );
    return;
  }

  final repo = providers.read(employeeRepositoryProvider);
  final upload = providers.read(mediaUploadServiceProvider);

  try {
    if (isEdit) {
      var url = photoUrl;
      if (photoFile != null) {
        url = await upload.uploadEmployeePhoto(
          businessId: businessId,
          employeeId: employee!.id,
          file: photoFile!,
        );
      }
      await repo.update(
        businessId: businessId,
        employeeId: employee!.id,
        firstName: firstName,
        lastName: lastName,
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        photoUrl: url,
        salary: salary,
        paymentDayOfMonth: paymentDay,
        reminderDaysBefore: reminderDays,
        active: active,
        showOnSite: showOnSite,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.employeeUpdated)),
        );
      }
    } else {
      final created = await repo.create(
        businessId: businessId,
        firstName: firstName,
        lastName: lastName,
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        salary: salary,
        paymentDayOfMonth: paymentDay,
        reminderDaysBefore: reminderDays,
        active: active,
        showOnSite: showOnSite,
      );
      var url = photoUrl;
      if (photoFile != null) {
        url = await upload.uploadEmployeePhoto(
          businessId: businessId,
          employeeId: created.id,
          file: photoFile!,
        );
        await repo.update(
          businessId: businessId,
          employeeId: created.id,
          firstName: firstName,
          lastName: lastName,
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          photoUrl: url,
          salary: salary,
          paymentDayOfMonth: paymentDay,
          reminderDaysBefore: reminderDays,
          active: active,
          showOnSite: showOnSite,
        );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.employeeCreated)),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric('$e'))),
      );
    }
  }
}

Future<void> deleteEmployee(
  BuildContext context,
  WidgetRef ref,
  Employee employee,
) async {
  final l10n = context.l10n;
  final confirmed = await showConfirmDeleteDialog(
    context,
    title: l10n.employeeDeleteTitle,
    message: l10n.employeeDeleteMessage(employee.fullName),
  );
  if (!confirmed || !context.mounted) return;

  final businessId = ref.read(currentBusinessIdProvider);
  if (businessId == null) return;

  try {
    await ref.read(employeeRepositoryProvider).delete(
          businessId: businessId,
          employeeId: employee.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.employeeDeleted)),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric('$e'))),
      );
    }
  }
}
