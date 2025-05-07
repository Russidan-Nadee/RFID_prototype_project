import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class GetAssetsUseCase {
  final AssetRepository _repository;

  GetAssetsUseCase(this._repository);

  Future<List<Asset>> execute() async {
    return await _repository.getAssets();
  }
}
