// lib/services/export_service/data/datasources/remote/asset_service_client.dart

import 'package:dio/dio.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../../../../../core/configuration/app_config.dart';
import '../../../../../shared/interfaces/asset_service_client_interface.dart';

class ExportAssetServiceClient implements AssetServiceClientInterface {
  final Dio _dio;

  ExportAssetServiceClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.assetServiceUrl,
          connectTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
        ),
      );

  @override
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

  @override
  Future<Map<String, dynamic>?> getAssetByUid(String uid) async {
    try {
      final response = await _dio.get('/assets/$uid');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      }

      return null;
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  @override
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
