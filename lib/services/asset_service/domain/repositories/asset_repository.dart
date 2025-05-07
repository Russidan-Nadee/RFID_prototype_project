import '../entities/asset.dart';

abstract class AssetRepository {
  // การจัดการสินทรัพย์
  Future<List<Asset>> getAssets();
  Future<Asset?> getAssetByUid(String uid);
  Future<bool> updateAssetStatus(String uid, String status);
  Future<Asset?> updateAsset(Asset asset);
  Future<void> insertAsset(Asset asset);
  Future<void> deleteAsset(String uid);
  Future<void> deleteAllAssets();
  Future<String?> getRandomUid();

  // การจัดการหมวดหมู่
  Future<List<String>> getCategories();
  Future<void> addCategory(String name);
  Future<void> updateCategory(String oldName, String newName);
  Future<void> deleteCategory(String name);

  // การจัดการแผนก
  Future<List<String>> getDepartments();
  Future<void> addDepartment(String name);
  Future<void> updateDepartment(String oldName, String newName);
  Future<void> deleteDepartment(String name);
}
