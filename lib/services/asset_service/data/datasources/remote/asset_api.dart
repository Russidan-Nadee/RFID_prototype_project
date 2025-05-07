import 'package:dio/dio.dart';
import '../../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../../core/exceptions/error_handler.dart';
import '../../../../../shared/models/api_response.dart';
import '../../../domain/entities/asset.dart';

class AssetApi {
  final Dio _dio;

  AssetApi() : _dio = Dio();

  Future<List<Asset>> getAssetsFromRemote() async {
    try {
      // สมมติว่ามีบริการภายนอกสำหรับดึงข้อมูลสินทรัพย์
      final response = await _dio.get('https://api.example.com/assets');

      final ApiResponse apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((json) => Asset.fromJson(json)).toList(),
      );

      if (!apiResponse.success) {
        throw FetchDataException(apiResponse.message);
      }

      return apiResponse.data ?? [];
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<Asset?> syncAssetWithRemote(Asset asset) async {
    try {
      // สมมติว่ามีบริการภายนอกสำหรับซิงค์ข้อมูลสินทรัพย์
      final response = await _dio.post(
        'https://api.example.com/assets/sync',
        data: asset.toJson(),
      );

      final ApiResponse apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => Asset.fromJson(data),
      );

      if (!apiResponse.success) {
        throw FetchDataException(apiResponse.message);
      }

      return apiResponse.data;
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }
}
