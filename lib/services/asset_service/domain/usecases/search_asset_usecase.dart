import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class SearchAssetUseCase {
  final AssetRepository _repository;

  SearchAssetUseCase(this._repository);

  Future<Asset?> execute(String uid) async {
    try {
      return await _repository.getAssetByUid(uid);
    } catch (e) {
      throw Exception('Error searching asset: $e');
    }
  }
}
