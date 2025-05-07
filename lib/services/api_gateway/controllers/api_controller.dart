import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shelf/shelf.dart';
import '../../../core/configuration/app_config.dart';
import '../../../core/exceptions/error_handler.dart';

class ApiController {
  final Dio _dio = Dio();

  // ดึงข้อมูลจาก Asset Service
  Future<Response> getAssets(Request request) async {
    try {
      final queryParameters = request.url.queryParameters;
      final response = await _dio.get(
        '${AppConfig.assetServiceUrl}/assets',
        queryParameters: queryParameters,
      );

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // ดึงข้อมูลสินทรัพย์ตาม UID
  Future<Response> getAssetByUid(Request request, String uid) async {
    try {
      final response = await _dio.get(
        '${AppConfig.assetServiceUrl}/assets/$uid',
      );

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // สร้างสินทรัพย์ใหม่
  Future<Response> createAsset(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final response = await _dio.post(
        '${AppConfig.assetServiceUrl}/assets',
        data: jsonData,
      );

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // อัปเดตสินทรัพย์
  Future<Response> updateAsset(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final response = await _dio.put(
        '${AppConfig.assetServiceUrl}/assets',
        data: jsonData,
      );

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // อัปเดตสถานะสินทรัพย์
  Future<Response> updateAssetStatus(Request request, String uid) async {
    try {
      final jsonData = await request.readAsString();
      final response = await _dio.put(
        '${AppConfig.assetServiceUrl}/assets/$uid/status',
        data: jsonData,
      );

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // ลบสินทรัพย์
  Future<Response> deleteAsset(Request request, String uid) async {
    try {
      final response = await _dio.delete(
        '${AppConfig.assetServiceUrl}/assets/$uid',
      );

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // สแกน RFID
  Future<Response> scanRfid(Request request) async {
    try {
      final response = await _dio.post('${AppConfig.rfidServiceUrl}/rfid/scan');

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // ดึงข้อมูล Dashboard
  Future<Response> getDashboardStats(Request request) async {
    try {
      final response = await _dio.get(
        '${AppConfig.dashboardServiceUrl}/dashboard/stats',
      );

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // ส่งออกข้อมูล
  Future<Response> exportAssets(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final response = await _dio.post(
        '${AppConfig.exportServiceUrl}/exports',
        data: jsonData,
      );

      return Response.ok(
        jsonEncode(response.data),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // ดาวน์โหลดไฟล์ที่ส่งออก
  Future<Response> downloadExport(Request request, String id) async {
    try {
      final response = await _dio.get(
        '${AppConfig.exportServiceUrl}/exports/$id',
        options: Options(responseType: ResponseType.bytes),
      );

      final contentType = response.headers.map['content-type']?.first;
      final contentDisposition =
          response.headers.map['content-disposition']?.first;

      return Response.ok(
        response.data,
        headers: {
          if (contentType != null) 'content-type': contentType,
          if (contentDisposition != null)
            'content-disposition': contentDisposition,
        },
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  // ตัวช่วยจัดการข้อผิดพลาด
  Response _handleError(dynamic error) {
    if (error is DioError) {
      if (error.response != null) {
        return Response(
          error.response!.statusCode ?? 500,
          body: jsonEncode(error.response!.data),
          headers: {'content-type': 'application/json'},
        );
      }
    }

    final exception = ErrorHandler.handleError(error);
    return Response.internalServerError(
      body: jsonEncode({'success': false, 'message': exception.message}),
      headers: {'content-type': 'application/json'},
    );
  }
}
