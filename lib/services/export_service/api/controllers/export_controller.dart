import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import '../../domain/entities/export_record.dart';
import '../../domain/repositories/export_repository.dart';

class ExportController {
  final ExportRepository _repository;

  ExportController(this._repository);

  // ดึงประวัติการส่งออก
  Future<Response> getExportHistory(Request request) async {
    try {
      final history = await _repository.getExportHistory();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': history.map((e) => e.toJson()).toList(),
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

  // ส่งออกข้อมูลสินทรัพย์
  Future<Response> exportAssets(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonData);

      // แปลงค่าจาก JSON
      final formatStr = data['format'] ?? 'csv';
      final ExportFormat format = _parseFormat(formatStr);
      final List<String> columns = List<String>.from(data['columns'] ?? []);
      final List<String>? statuses =
          data['statuses'] != null ? List<String>.from(data['statuses']) : null;

      // ตรวจสอบว่ามีคอลัมน์ที่จะส่งออกหรือไม่
      if (columns.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'ต้องระบุคอลัมน์ที่ต้องการส่งออกอย่างน้อย 1 คอลัมน์',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // ส่งออกข้อมูล
      final exportRecord = await _repository.exportAssets(
        format,
        columns,
        statuses,
      );

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'ส่งออกข้อมูลสำเร็จ',
          'data': exportRecord.toJson(),
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

  // ดาวน์โหลดไฟล์ที่ส่งออก
  Future<Response> downloadExport(Request request, String id) async {
    try {
      final exportId = int.tryParse(id);
      if (exportId == null) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'รหัสการส่งออกไม่ถูกต้อง',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      final filePath = await _repository.getExportFilePath(exportId);
      if (filePath == null) {
        return Response.notFound(
          jsonEncode({'success': false, 'message': 'ไม่พบไฟล์ที่ส่งออก'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final file = File(filePath);
      if (!await file.exists()) {
        return Response.notFound(
          jsonEncode({'success': false, 'message': 'ไม่พบไฟล์ที่ส่งออกในระบบ'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final bytes = await file.readAsBytes();
      final filename = filePath.split('/').last;
      final contentType = _getContentType(filename);

      return Response.ok(
        bytes,
        headers: {
          'content-type': contentType,
          'content-disposition': 'attachment; filename="$filename"',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // ลบการส่งออก
  Future<Response> deleteExport(Request request, String id) async {
    try {
      final exportId = int.tryParse(id);
      if (exportId == null) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'รหัสการส่งออกไม่ถูกต้อง',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      await _repository.deleteExport(exportId);

      return Response.ok(
        jsonEncode({'success': true, 'message': 'ลบการส่งออกสำเร็จ'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  ExportFormat _parseFormat(String format) {
    switch (format.toLowerCase()) {
      case 'csv':
        return ExportFormat.csv;
      case 'excel':
        return ExportFormat.excel;
      case 'pdf':
        return ExportFormat.pdf;
      case 'json':
        return ExportFormat.json;
      default:
        return ExportFormat.csv;
    }
  }

  String _getContentType(String filename) {
    if (filename.endsWith('.csv')) {
      return 'text/csv';
    } else if (filename.endsWith('.xlsx')) {
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    } else if (filename.endsWith('.pdf')) {
      return 'application/pdf';
    } else if (filename.endsWith('.json')) {
      return 'application/json';
    } else {
      return 'application/octet-stream';
    }
  }
}
