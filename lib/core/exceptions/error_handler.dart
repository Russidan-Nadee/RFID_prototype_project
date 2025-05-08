import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exceptions.dart';

class ErrorHandler {
  static AppException handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return FetchDataException('ไม่สามารถเชื่อมต่ออินเตอร์เน็ตได้');
    } else if (error is FormatException) {
      return BadRequestException('ข้อมูลมีรูปแบบไม่ถูกต้อง');
    } else if (error is AppException) {
      return error;
    } else {
      return FetchDataException(
        'เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ: ${error.toString()}',
      );
    }
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return FetchDataException('หมดเวลาการเชื่อมต่อ');
      case DioExceptionType.badResponse:
        return _handleResponseError(
          error.response?.statusCode ?? 500,
          error.response?.data ?? 'เกิดข้อผิดพลาดที่เซิร์ฟเวอร์',
        );
      case DioExceptionType.cancel:
        return FetchDataException('ยกเลิกการเชื่อมต่อ');
      default:
        return FetchDataException('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ');
    }
  }

  static AppException _handleResponseError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return BadRequestException(_extractErrorMessage(error));
      case 401:
        return UnauthorizedException(_extractErrorMessage(error));
      case 404:
        return NotFoundException(_extractErrorMessage(error));
      default:
        return FetchDataException(_extractErrorMessage(error));
    }
  }

  static String _extractErrorMessage(dynamic error) {
    if (error is Map<String, dynamic> && error.containsKey('message')) {
      return error['message'].toString();
    } else if (error is String) {
      return error;
    } else {
      return 'เกิดข้อผิดพลาด';
    }
  }
}
