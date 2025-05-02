import '../../domain/entities/asset.dart';
import '../../domain/repositories/asset_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/asset_model.dart';

class AssetRepositoryImpl implements AssetRepository {
  final DatabaseHelper _databaseHelper;

  AssetRepositoryImpl(this._databaseHelper);

  @override
  Future<List<Asset>> getAssets() async {
    final assetsMaps = await _databaseHelper.getAssets();
    return assetsMaps.map((map) => AssetModel.fromMap(map)).toList();
  }

  @override
  Future<Asset?> getAssetByUid(String uid) async {
    final assetMap = await _databaseHelper.getAssetByUid(uid);
    if (assetMap == null) return null;
    return AssetModel.fromMap(assetMap);
  }

  @override
  Future<bool> updateAssetStatus(String uid, String status) async {
    return await _databaseHelper.updateStatus(uid, status);
  }

  @override
  Future<void> insertAsset(Asset asset) async {
    final assetModel = asset as AssetModel;
    await _databaseHelper.insertNewAsset(
      assetModel.id,
      assetModel.category,
      assetModel.brand,
      assetModel.department,
      assetModel.uid,
      assetModel.date,
    );
  }

  @override
  Future<void> deleteAsset(String uid) async {
    await _databaseHelper.deleteAssetByUid(uid);
  }

  @override
  Future<void> deleteAllAssets() async {
    await _databaseHelper.deleteAllAssets();
  }
}
