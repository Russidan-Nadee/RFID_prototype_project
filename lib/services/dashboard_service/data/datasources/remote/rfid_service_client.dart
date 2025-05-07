import 'package:dio/dio.dart';
import '../../../../../../core/configuration/app_config.dart';
import '../../../../../../core/exceptions/error_handler.dart';

class RfidServiceClient {
  final Dio _dio;

  RfidServiceClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.rfidServiceUrl,
          connectTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
        ),
      );

  Future<Map<String, int>> getScanHistoryByDay() async {
    try {
      final response = await _dio.get('/rfid/scan-history');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          // แปลงข้อมูลจาก JSON เป็น Map<String, int>
          final historyData = data['data'] as Map<String, dynamic>;
          return historyData.map((key, value) => MapEntry(key, value as int));
        }
      }

      return {};
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<int> getScanCountToday() async {
    try {
      final response = await _dio.get('/rfid/scan-count-today');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return data['data']['count'] ?? 0;
        }
      }

      return 0;
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }
}
