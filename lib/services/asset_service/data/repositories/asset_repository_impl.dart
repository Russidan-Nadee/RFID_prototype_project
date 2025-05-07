import '../../domain/entities/asset.dart';
import '../../domain/repositories/asset_repository.dart';
import '../datasources/local/asset_database.dart';
import '../models/asset_model.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetDatabase _database;

  AssetRepositoryImpl(this._database);

  @override
  Future<List<Asset>> getAssets() async {
    final assetMaps = await _database.getAssets();
    return assetMaps.map((map) => AssetModel.fromMap(map)).toList();
  }

  @override
  Future<Asset?> getAssetByUid(String uid) async {
    final assetMap = await _database.getAssetByUid(uid);
    if (assetMap == null) return null;
    return AssetModel.fromMap(assetMap);
  }

  @override
  Future<bool> updateAssetStatus(String uid, String status) async {
    return await _database.updateAssetStatus(uid, status);
  }

  @override
  Future<Asset?> updateAsset(Asset asset) async {
    final assetModel = AssetModel.fromEntity(asset);
    final success = await _database.updateAsset(assetModel.toMap());
    return success ? asset : null;
  }

  @override
  Future<void> insertAsset(Asset asset) async {
    final assetModel = AssetModel.fromEntity(asset);
    await _database.insertAsset(assetModel.toMap());
  }

  @override
  Future<void> deleteAsset(String uid) async {
    await _database.deleteAsset(uid);
  }

  @override
  Future<void> deleteAllAssets() async {
    await _database.deleteAllAssets();
  }

  @override
  Future<List<String>> getCategories() async {
    return await _database.getCategories();
  }

  @override
  Future<void> addCategory(String name) async {
    await _database.addCategory(name);
  }

  @override
  Future<void> updateCategory(String oldName, String newName) async {
    await _database.updateCategory(oldName, newName);
  }

  @override
  Future<void> deleteCategory(String name) async {
    await _database.deleteCategory(name);
  }

  @override
  Future<List<String>> getDepartments() async {
    return await _database.getDepartments();
  }

  @override
  Future<void> addDepartment(String name) async {
    await _database.addDepartment(name);
  }

  @override
  Future<void> updateDepartment(String oldName, String newName) async {
    await _database.updateDepartment(oldName, newName);
  }

  @override
  Future<void> deleteDepartment(String name) async {
    await _database.deleteDepartment(name);
  }

  @override
  Future<String?> getRandomUid() async {
    return await _database.getRandomUid();
  }
}
