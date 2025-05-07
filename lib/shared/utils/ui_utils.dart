import 'package:flutter/material.dart';

class UiUtils {
  // แสดง SnackBar
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  // แสดง Dialog ยืนยัน
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'ยืนยัน',
    String cancelText = 'ยกเลิก',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(cancelText),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style:
                    confirmColor != null
                        ? TextButton.styleFrom(foregroundColor: confirmColor)
                        : null,
                child: Text(confirmText),
              ),
            ],
          ),
    );
    return result ?? false;
  }

  // แสดง Loading Dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'กำลังโหลด...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(message),
              ],
            ),
          ),
    );
  }

  // ซ่อน Loading Dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // คำนวณสีที่เหมาะสมกับพื้นหลัง
  static Color getContrastColor(Color backgroundColor) {
    final luminance =
        (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
