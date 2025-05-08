import 'package:dio/dio.dart';
import '../../../../../../core/configuration/app_config.dart';
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

  Future<bool> checkAssetExists(String uid) async {
    try {
      final response = await _dio.get('/assets/$uid');

      if (response.statusCode == 200) {
        final data = response.data;
        return data['success'] == true;
      }

      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // สินทรัพย์ไม่พบ ถือว่าปกติ
        return false;
      }

      // มีปัญหาอื่นๆ กับการเชื่อมต่อ
      throw ErrorHandler.handleError(e);
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

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
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // สินทรัพย์ไม่พบ ส่งค่า null กลับไป
        return null;
      }

      // มีปัญหาอื่นๆ กับการเชื่อมต่อ
      throw ErrorHandler.handleError(e);
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }
}
