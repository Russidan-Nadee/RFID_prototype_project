import 'package:shelf/shelf.dart';

class LoggingMiddleware {
  Middleware get handle {
    return (Handler innerHandler) {
      return (Request request) async {
        // บันทึกเวลาเริ่มต้น
        final startTime = DateTime.now();

        // พิมพ์ข้อมูลการเรียก API
        print('[$startTime] ${request.method} ${request.url.path}');

        // ดำเนินการต่อไปยัง middleware ถัดไปหรือ handler
        final response = await innerHandler(request);

        // คำนวณเวลาที่ใช้
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime);

        // พิมพ์ข้อมูลการตอบกลับ
        print(
          '[$endTime] ${response.statusCode} (${duration.inMilliseconds}ms)',
        );

        return response;
      };
    };
  }
}
