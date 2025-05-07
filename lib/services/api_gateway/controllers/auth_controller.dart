import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:crypto/crypto.dart';

class AuthController {
  // สำหรับเก็บข้อมูลผู้ใช้จำลอง (ในระบบจริงควรใช้ฐานข้อมูล)
  final Map<String, Map<String, dynamic>> _users = {
    'admin': {
      'username': 'admin',
      'password': _hashPassword('admin'),
      'role': 'admin',
    },
    'user': {
      'username': 'user',
      'password': _hashPassword('user'),
      'role': 'user',
    },
  };

  // สำหรับเก็บ tokens ที่ถูกออกไป
  final Map<String, Map<String, dynamic>> _tokens = {};

  // เข้าสู่ระบบ
  Future<Response> login(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonData);

      final username = data['username'];
      final password = data['password'];

      if (username == null || password == null) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'กรุณาระบุชื่อผู้ใช้และรหัสผ่าน',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      final user = _users[username];
      if (user == null || user['password'] != _hashPassword(password)) {
        return Response.forbidden(
          jsonEncode({
            'success': false,
            'message': 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // สร้าง token
      final token = _generateToken();
      final expiresAt = DateTime.now().add(Duration(hours: 24));

      _tokens[token] = {
        'username': username,
        'role': user['role'],
        'expiresAt': expiresAt.millisecondsSinceEpoch,
      };

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'เข้าสู่ระบบสำเร็จ',
          'data': {
            'token': token,
            'username': username,
            'role': user['role'],
            'expiresAt': expiresAt.millisecondsSinceEpoch,
          },
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // ออกจากระบบ
  Future<Response> logout(Request request) async {
    try {
      final authorization = request.headers['authorization'];
      if (authorization == null || !authorization.startsWith('Bearer ')) {
        return Response.ok(
          jsonEncode({'success': true, 'message': 'ออกจากระบบสำเร็จ'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final token = authorization.substring(7);
      _tokens.remove(token);

      return Response.ok(
        jsonEncode({'success': true, 'message': 'ออกจากระบบสำเร็จ'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // ตรวจสอบข้อมูลผู้ใช้ปัจจุบัน
  Future<Response> getProfile(Request request) async {
    try {
      final user = _getUserFromRequest(request);
      if (user == null) {
        return Response.forbidden(
          jsonEncode({'success': false, 'message': 'ไม่ได้เข้าสู่ระบบ'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {'username': user['username'], 'role': user['role']},
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // ตรวจสอบ token จาก request
  Map<String, dynamic>? validateToken(String token) {
    final tokenData = _tokens[token];
    if (tokenData == null) return null;

    final expiresAt = tokenData['expiresAt'] as int;
    if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
      _tokens.remove(token);
      return null;
    }

    return tokenData;
  }

  // ดึงข้อมูลผู้ใช้จาก request
  Map<String, dynamic>? _getUserFromRequest(Request request) {
    final authorization = request.headers['authorization'];
    if (authorization == null || !authorization.startsWith('Bearer ')) {
      return null;
    }

    final token = authorization.substring(7);
    final tokenData = validateToken(token);
    if (tokenData == null) return null;
    final username = tokenData['username'] as String;
    return {'username': username, 'role': tokenData['role']};
  }

  // สร้าง token
  String _generateToken() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = sha256.convert(utf8.encode(random)).toString();
    return hash;
  }

  // เข้ารหัสรหัสผ่าน
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
