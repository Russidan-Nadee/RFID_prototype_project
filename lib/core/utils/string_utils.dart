import 'dart:math';

class StringUtils {
  static String capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidUid(String uid) {
    return uid.length == 10;
  }

  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static String sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[^\w\s\-\.]'), '_');
  }

  static String? getFileExtension(String fileName) {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last : null;
  }

  static String getInitials(String fullName) {
    final nameParts = fullName.split(' ');
    final initials = nameParts
        .map((part) => part.isNotEmpty ? part[0] : '')
        .join('');
    return initials.toUpperCase();
  }
}

// ฟังก์ชันคณิตศาสตร์ที่จำเป็น


// การพัฒนา IDE อาจจะแจ้งเตือนว่า pow เป็นส่วนหนึ่งของ dart:math
// ดังนั้นจึงต้องใช้ import dart:math ด้านบน