import 'package:dio/dio.dart';
import 'package:rfid_project/waitforedit/corewait/config/app_config.dart';
import '../../../../../../core/exceptions/error_handler.dart';

class AssetServiceClient {
  final Dio _dio;

  AssetServiceClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.assetServiceUrl,
          connectTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
        ),
      );

  Future<List<Map<String, dynamic>>> getAssets() async {
    try {
      final response = await _dio.get('/assets');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      return [];
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/categories');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return List<String>.from(data['data']);
        }
      }

      return [];
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<List<String>> getDepartments() async {
    try {
      final response = await _dio.get('/departments');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return List<String>.from(data['data']);
        }
      }

      return [];
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }
}
