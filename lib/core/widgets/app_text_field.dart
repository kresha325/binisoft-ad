import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_input_styles.dart';
import '../theme/app_theme.dart';

/// Label above field — matches JKR auth forms (not floating label).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.helperText,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.fieldLabel(context)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          style: AppInputStyles.fieldText(context),
          cursorColor: context.appColors.accent,
          decoration: AppInputStyles.decoration(
            context,
            hintText: hint,
            helperText: helperText,
          ),
        ),
      ],
    );
  }
}
