import 'dart:async';

import 'package:auth_katalog_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 200)
    ..indicatorType = .ring
    ..loadingStyle = .custom
    ..indicatorSize = 35.0
    ..lineWidth = 2
    ..radius = 10.0
    ..progressColor = AppColors.kPrimaryColor
    ..backgroundColor = AppColors.kBgColor
    ..indicatorColor = AppColors.kPrimaryColor
    ..textColor = AppColors.kTextColor
    ..maskColor = Colors.black.withValues(alpha: 0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..maskType = .custom;
}

/// Loading untuk nunjukin loading tanpa context
class Loading {
  static void show([String? text]) {
    EasyLoading.instance.userInteractions = false;
    unawaited(EasyLoading.show(status: text ?? 'Please Wait'));
  }

  static void toast(String text) {
    EasyLoading.instance.userInteractions = true;
    unawaited(EasyLoading.showToast(text, duration: Durations.extralong4));
  }

  static void error(String text) {
    unawaited(EasyLoading.showError(text, duration: Durations.extralong4));
  }

  static void success(String text) {
    unawaited(EasyLoading.showSuccess(text, duration: Durations.extralong4));
  }

  static void dismiss() {
    EasyLoading.instance.userInteractions = true;
    unawaited(EasyLoading.dismiss());
  }
}
