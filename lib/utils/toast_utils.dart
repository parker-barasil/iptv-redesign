import 'package:flutter/material.dart';
import '../widgets/custom_toast.dart';

class ToastUtils {
  static void showSuccess(BuildContext context, String message) {
    CustomToast.show(
      context,
      message: message,
      type: ToastType.success,
    );
  }

  static void showError(BuildContext context, String message) {
    CustomToast.show(
      context,
      message: message,
      type: ToastType.error,
    );
  }

  static void showInfo(BuildContext context, String message) {
    CustomToast.show(
      context,
      message: message,
      type: ToastType.info,
    );
  }

  static void showWarning(BuildContext context, String message) {
    CustomToast.show(
      context,
      message: message,
      type: ToastType.warning,
    );
  }
}
