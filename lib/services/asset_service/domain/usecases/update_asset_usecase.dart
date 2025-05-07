import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class UpdateAssetUseCase {
  final AssetRepository _repository;

  UpdateAssetUseCase(this._repository);

  Future<Asset?> execute(Asset asset) async {
    return await _repository.updateAsset(asset);
  }

  Future<bool> updateStatus(String uid, String status) async {
    return await _repository.updateAssetStatus(uid, status);
  }
}
