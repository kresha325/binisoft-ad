import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_input_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../domain/entities/attribute_definition.dart';
import 'color_swatch_picker.dart';

/// Builds form fields for dynamic product attributes.
class AttributeFieldBuilder extends StatefulWidget {
  const AttributeFieldBuilder({
    super.key,
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  final AttributeDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  @override
  State<AttributeFieldBuilder> createState() => _AttributeFieldBuilderState();
}

class _AttributeFieldBuilderState extends State<AttributeFieldBuilder> {
  TextEditingController? _controller;

  String get _label => widget.definition.name + (widget.definition.required ? ' *' : '');

  String get _textValue {
    final v = widget.value;
    if (v == null) return '';
    return v.toString();
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(AttributeFieldBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.definition.id != widget.definition.id) {
      _controller?.dispose();
      _controller = null;
      _initController();
    }
  }

  void _initController() {
    if (_usesTextController) {
      _controller = TextEditingController(text: _textValue);
    }
  }

  bool get _usesTextController {
    switch (widget.definition.type) {
      case AttributeType.text:
      case AttributeType.textarea:
      case AttributeType.number:
        return true;
      case AttributeType.color:
        return false;
      default:
        return false;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(BuildContext context) =>
      AppInputStyles.decoration(context);

  void _onTextChanged(String text) {
    switch (widget.definition.type) {
      case AttributeType.number:
        if (text.trim().isEmpty) {
          widget.onChanged(null);
        } else {
          widget.onChanged(num.tryParse(text) ?? text);
        }
      default:
        widget.onChanged(text);
    }
  }

  Widget _textField({
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(_label, style: AppTextStyles.fieldLabel(context)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppInputStyles.fieldText(context),
          cursorColor: context.appColors.accent,
          decoration: _fieldDecoration(context),
          onChanged: _onTextChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    switch (widget.definition.type) {
      case AttributeType.text:
        return _textField();
      case AttributeType.textarea:
        return _textField(maxLines: 4);
      case AttributeType.number:
        return _textField(keyboardType: TextInputType.number);
      case AttributeType.select:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_label, style: AppTextStyles.fieldLabel(context)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: _fieldDecoration(context),
              dropdownColor: colors.surface,
              style: AppInputStyles.fieldText(context),
              initialValue: widget.value as String?,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text('Select', style: AppInputStyles.fieldText(context)),
                ),
                for (final o in widget.definition.options)
                  DropdownMenuItem(
                    value: o,
                    child: Text(o, style: AppInputStyles.fieldText(context)),
                  ),
              ],
              onChanged: widget.onChanged,
            ),
          ],
        );
      case AttributeType.multiSelect:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_label, style: AppTextStyles.fieldLabel(context)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final o in widget.definition.options)
                  FilterChip(
                    label: Text(o, style: GoogleFonts.inter(color: colors.textPrimary)),
                    selected: (widget.value as List<String>? ?? []).contains(o),
                    selectedColor: colors.accentSoft,
                    checkmarkColor: colors.accent,
                    side: BorderSide(color: colors.cardBorder),
                    onSelected: (selected) {
                      final list = List<String>.from(widget.value as List? ?? []);
                      if (selected) {
                        list.add(o);
                      } else {
                        list.remove(o);
                      }
                      widget.onChanged(list);
                    },
                  ),
              ],
            ),
          ],
        );
      case AttributeType.color:
        return ColorSwatchPicker(
          label: _label,
          value: widget.value,
          onChanged: (v) => widget.onChanged(v),
        );
      case AttributeType.boolean:
        return AppSwitchRow(
          label: _label,
          value: widget.value == true,
          onChanged: widget.onChanged,
        );
    }
  }
}
