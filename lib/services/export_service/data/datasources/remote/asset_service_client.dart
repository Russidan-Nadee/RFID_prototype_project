import 'package:dio/dio.dart';
import '../../../../../../core/exceptions/error_handler.dart';
import 'package:rfid_project/core/configuration/app_config.dart';

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

  Future<List<Map<String, dynamic>>> getFilteredAssets(
    List<String>? statuses,
  ) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (statuses != null && statuses.isNotEmpty) {
        queryParameters['statuses'] = statuses.join(',');
      }

      final response = await _dio.get(
        '/assets',
        queryParameters: queryParameters,
      );

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
}
