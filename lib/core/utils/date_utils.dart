import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(dateTime);
  }

  static String getFormattedToday({String format = 'yyyy-MM-dd'}) {
    return formatDate(DateTime.now(), format: format);
  }

  static DateTime parseDate(String dateString, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).parse(dateString);
  }

  static String timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ปีที่แล้ว';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} เดือนที่แล้ว';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} วันที่แล้ว';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else {
      return 'เมื่อสักครู่';
    }
  }

  static String getThaiMonth(int month) {
    const thaiMonths = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];
    return thaiMonths[month - 1];
  }

  static String formatThaiDate(DateTime dateTime) {
    final day = dateTime.day;
    final month = getThaiMonth(dateTime.month);
    final year = dateTime.year + 543; // แปลงเป็นพุทธศักราช
    return '$day $month $year';
  }
}
