import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../domain/repositories/rfid_repository.dart';

class RfidController {
  final RfidRepository _repository;

  RfidController(this._repository);

  // สแกน RFID
  Future<Response> scanRfid(Request request) async {
    try {
      final scan = await _repository.scanRfid();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {
            'uid': scan.uid,
            'scanTime': scan.scanTime.toIso8601String(),
            'isFound': scan.isFound,
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

  // สแกน RFID จำลอง (ระบุว่าต้องการเจอสินทรัพย์หรือไม่)
  Future<Response> mockScanRfid(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonData);

      final shouldFind = data['shouldFind'] ?? true;
      final scan = await _repository.mockScanRfid(shouldFind);

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {
            'uid': scan.uid,
            'scanTime': scan.scanTime.toIso8601String(),
            'isFound': scan.isFound,
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

  // ตรวจสอบสถานะอุปกรณ์ RFID
  Future<Response> checkDeviceStatus(Request request) async {
    try {
      final isAvailable = await _repository.isDeviceAvailable();
      final isScanning = _repository.isScanning();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {'isAvailable': isAvailable, 'isScanning': isScanning},
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

  // ตั้งค่าโหมดการจำลอง
  Future<Response> setMockMode(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonData);

      final mode = data['mode'] ?? 'normal';
      await _repository.setMockMode(mode);

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'ตั้งค่าโหมดจำลองเป็น $mode สำเร็จ',
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

  // ดึงค่าโหมดการจำลองปัจจุบัน
  Future<Response> getMockMode(Request request) async {
    try {
      final mode = _repository.getCurrentMockMode();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {'mode': mode},
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
}
