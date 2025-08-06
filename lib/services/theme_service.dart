import 'package:flutter/material.dart';

class ThemeService {
  static const Color primaryColor = Colors.orange;
  static const Color catColor = Colors.black;
  static const Color fenceColor = Colors.brown;
  
  static Color getCellColor(BuildContext context, bool isSelected) {
    final theme = Theme.of(context);
    if (isSelected) {
      return theme.colorScheme.primary.withOpacity(0.3);
    }
    return theme.colorScheme.surface;
  }
  
  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).colorScheme.outline;
  }
}
