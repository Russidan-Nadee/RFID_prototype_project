// asset_service_client_interface.dart
abstract class AssetServiceClientInterface {
  Future<List<Map<String, dynamic>>> getAssets();
  Future<Map<String, dynamic>?> getAssetByUid(String uid);
  Future<List<Map<String, dynamic>>> getFilteredAssets(List<String>? statuses);
  // เพิ่มเมธอดอื่นๆ ที่จำเป็นตามการใช้งานจริงของคุณ
}
