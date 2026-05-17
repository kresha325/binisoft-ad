import 'package:collection/collection.dart';

/// Preset product colors — name + hex for swatch picker.
class PresetColor {
  const PresetColor({required this.name, required this.hex});

  final String name;
  final String hex;

  Map<String, String> toValue() => {'name': name, 'hex': hex};
}

const presetProductColors = <PresetColor>[
  PresetColor(name: 'Black', hex: '#171717'),
  PresetColor(name: 'White', hex: '#FFFFFF'),
  PresetColor(name: 'Gray', hex: '#6B7280'),
  PresetColor(name: 'Silver', hex: '#C0C0C0'),
  PresetColor(name: 'Red', hex: '#DC2626'),
  PresetColor(name: 'Navy', hex: '#1E3A5F'),
  PresetColor(name: 'Blue', hex: '#2563EB'),
  PresetColor(name: 'Green', hex: '#16A34A'),
  PresetColor(name: 'Yellow', hex: '#EAB308'),
  PresetColor(name: 'Orange', hex: '#EA580C'),
  PresetColor(name: 'Pink', hex: '#DB2777'),
  PresetColor(name: 'Purple', hex: '#7C3AED'),
  PresetColor(name: 'Brown', hex: '#92400E'),
  PresetColor(name: 'Beige', hex: '#D6C4A8'),
  PresetColor(name: 'Gold', hex: '#CA8A04'),
  PresetColor(name: 'Burgundy', hex: '#7F1D1D'),
  PresetColor(name: 'Teal', hex: '#0D9488'),
  PresetColor(name: 'Cream', hex: '#FEF3C7'),
];

class SelectedProductColor {
  const SelectedProductColor({required this.name, required this.hex});

  final String name;
  final String hex;

  Map<String, String> toMap() => {'name': name, 'hex': hex};

  static SelectedProductColor? fromDynamic(dynamic value) {
    if (value == null) return null;

    if (value is Map) {
      final name = value['name']?.toString().trim() ?? '';
      final hex = (value['hex'] ?? value['color'])?.toString().trim() ?? '';
      if (name.isNotEmpty || hex.isNotEmpty) {
        return SelectedProductColor(
          name: name.isNotEmpty ? name : _nameForHex(hex),
          hex: hex.isNotEmpty ? _normalizeHex(hex) : '',
        );
      }
      return null;
    }

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    if (text.contains('|')) {
      final parts = text.split('|');
      return SelectedProductColor(
        name: parts.first.trim(),
        hex: _normalizeHex(parts.length > 1 ? parts[1] : ''),
      );
    }

    if (text.startsWith('#')) {
      return SelectedProductColor(name: _nameForHex(text), hex: _normalizeHex(text));
    }

    final preset = presetProductColors
        .where((c) => c.name.toLowerCase() == text.toLowerCase())
        .firstOrNull;
    if (preset != null) {
      return SelectedProductColor(name: preset.name, hex: preset.hex);
    }

    return SelectedProductColor(name: text, hex: '');
  }

  static String _normalizeHex(String hex) {
    final h = hex.trim();
    if (h.isEmpty) return '';
    return h.startsWith('#') ? h.toUpperCase() : '#${h.toUpperCase()}';
  }

  static String _nameForHex(String hex) {
    final normalized = _normalizeHex(hex).toUpperCase();
    for (final preset in presetProductColors) {
      if (preset.hex.toUpperCase() == normalized) return preset.name;
    }
    return normalized;
  }

  bool matches(PresetColor preset) =>
      preset.hex.toUpperCase() == hex.toUpperCase() &&
      preset.name.toLowerCase() == name.toLowerCase();
}
