import 'package:flutter/material.dart';

class ThemeService {
  static Color get primaryColorLight => const Color(0xFF2563EB);
  static Color get primaryColorDark => const Color(0xFF3B82F6);

  static Color get catColorLight => const Color(0xFF111827);
  static Color get catColorDark => const Color(0xFFF9FAFB);

  static Color get fenceColorLight => const Color(0xFFD1D5DB);
  static Color get fenceColorDark => const Color(0xFF4B5563);

  static Color getCellColor(BuildContext context, bool isSelected) {
    final theme = Theme.of(context);
    if (isSelected) {
      return theme.colorScheme.primary;
    }
    return theme.colorScheme.surface;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).colorScheme.outline;
  }
}
