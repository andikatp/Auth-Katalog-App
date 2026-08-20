import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool isDark = false;

  static const Color kPrimaryColor = Color(0xFF00abe0);
  static Color get kBgColor =>
      isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
  static Color get kInputColor =>
      isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  static Color get kBorderColor =>
      isDark ? const Color(0xFF334155) : const Color(0xFFCFCFCF);
  static Color get kTextColor =>
      isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
}
