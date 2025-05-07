import 'package:intl/intl.dart';

String formatDate(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
  return DateFormat(format).format(dateTime);
}

String getFormattedToday({String format = 'yyyy-MM-dd'}) {
  return formatDate(DateTime.now(), format: format);
}

DateTime parseDate(String dateString, {String format = 'yyyy-MM-dd'}) {
  return DateFormat(format).parse(dateString);
}

String timeAgo(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 365) {
    return '${(difference.inDays / 365).floor()} years ago';
  } else if (difference.inDays > 30) {
    return '${(difference.inDays / 30).floor()} months ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} days ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}
