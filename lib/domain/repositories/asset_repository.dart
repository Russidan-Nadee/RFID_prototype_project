import '../entities/asset.dart';

abstract class AssetRepository {
  Future<List<Asset>> getAssets();
  Future<Asset?> getAssetByUid(String uid);
  Future<bool> updateAssetStatus(String uid, String status);
  Future<void> insertAsset(Asset asset);
  Future<void> deleteAsset(String uid);
  Future<void> deleteAllAssets();
}
