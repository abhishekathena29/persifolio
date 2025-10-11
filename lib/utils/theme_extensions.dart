import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  // Quick access to theme colors
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get cardColor => Theme.of(this).cardColor;
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;

  // Text colors with WCAG AA compliance
  Color get textPrimaryColor =>
      Theme.of(this).textTheme.bodyLarge?.color ??
      (isDarkMode ? Colors.white : const Color(0xFF1A1A1A));
  Color get textSecondaryColor =>
      Theme.of(this).textTheme.bodySmall?.color ??
      (isDarkMode ? Colors.grey.shade400 : const Color(0xFF666666));

  // Container colors for adaptive UI
  Color get containerColor =>
      isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF8F8F8);
  Color get containerColorDark =>
      isDarkMode ? const Color(0xFF0F0F0F) : const Color(0xFFF0F0F0);

  // Border colors
  Color get borderColor =>
      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

  // Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
