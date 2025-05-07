import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardController {
  final DashboardRepository _repository;

  DashboardController(this._repository);

  // ดึงข้อมูลสถิติสำหรับ Dashboard
  Future<Response> getDashboardStats(Request request) async {
    try {
      final stats = await _repository.getDashboardStats();

      return Response.ok(
        jsonEncode({'success': true, 'data': stats.toJson()}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // ดึงข้อมูลการกระจายตัวของหมวดหมู่
  Future<Response> getCategoryDistribution(Request request) async {
    try {
      final distribution = await _repository.getCategoryDistribution();

      return Response.ok(
        jsonEncode({'success': true, 'data': distribution}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // ดึงข้อมูลการกระจายตัวของแผนก
  Future<Response> getDepartmentDistribution(Request request) async {
    try {
      final distribution = await _repository.getDepartmentDistribution();

      return Response.ok(
        jsonEncode({'success': true, 'data': distribution}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // ดึงข้อมูลประวัติการสแกนแยกตามวัน
  Future<Response> getScanHistoryByDay(Request request) async {
    try {
      final history = await _repository.getScanHistoryByDay();

      return Response.ok(
        jsonEncode({'success': true, 'data': history}),
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
