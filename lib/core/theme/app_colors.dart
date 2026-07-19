import 'package:flutter/material.dart';

/// Dark-first palette tuned for a fast-paced POS screen:
/// high contrast, low eye-strain, clear success/debt/warning states.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceElevated = Color(0xFF2A2A2A);

  static const Color primary = Color(0xFF00C2A8); // brand accent (cash/success actions)
  static const Color danger = Color(0xFFFF5C5C); // debt / low stock alerts
  static const Color warning = Color(0xFFFFB020); // near-low-stock warning
  static const Color info = Color(0xFF4EA1FF);

  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFA0A0A0);

  static const Color divider = Color(0xFF333333);
}
