import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../controllers/auth_controller.dart';

class AuthMiddleware {
  final AuthController _authController = AuthController();

  // รายการ paths ที่ไม่จำเป็นต้องตรวจสอบตัวตน
  final List<String> _publicPaths = ['/auth/login', '/auth/register'];

  // รายการ paths ที่ต้องเป็น admin เท่านั้น
  final List<String> _adminPaths = ['/exports/delete', '/settings'];

  Middleware get handle {
    return (Handler innerHandler) {
      return (Request request) async {
        // ตรวจสอบว่าเป็น path ที่ไม่ต้องตรวจสอบตัวตนหรือไม่
        final path = request.url.path;
        if (_isPublicPath(path)) {
          return innerHandler(request);
        }

        // ตรวจสอบ token
        final authorization = request.headers['authorization'];
        if (authorization == null || !authorization.startsWith('Bearer ')) {
          return Response.forbidden(
            jsonEncode({
              'success': false,
              'message': 'ไม่ได้รับอนุญาต กรุณาเข้าสู่ระบบก่อน',
            }),
            headers: {'content-type': 'application/json'},
          );
        }

        final token = authorization.substring(7);
        final userData = _authController.validateToken(token);

        if (userData == null) {
          return Response.forbidden(
            jsonEncode({
              'success': false,
              'message': 'ไม่ได้รับอนุญาต token หมดอายุหรือไม่ถูกต้อง',
            }),
            headers: {'content-type': 'application/json'},
          );
        }

        // ตรวจสอบสิทธิ์ของผู้ใช้ (เฉพาะบาง paths)
        if (_isAdminPath(path) && userData['role'] != 'admin') {
          return Response.forbidden(
            jsonEncode({
              'success': false,
              'message': 'ไม่มีสิทธิ์เข้าถึง ต้องเป็น admin เท่านั้น',
            }),
            headers: {'content-type': 'application/json'},
          );
        }

        // เพิ่มข้อมูลผู้ใช้เข้าไปใน context
        final updatedRequest = request.change(context: {'user': userData});

        return innerHandler(updatedRequest);
      };
    };
  }

  bool _isPublicPath(String path) {
    return _publicPaths.any((p) => path.startsWith(p));
  }

  bool _isAdminPath(String path) {
    return _adminPaths.any((p) => path.startsWith(p));
  }
}
