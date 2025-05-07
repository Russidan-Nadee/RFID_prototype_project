import 'package:rfid_project/waitforedit/domain/entities/asset.dart';
import 'package:rfid_project/waitforedit/domain/repositories/asset_repository.dart';

class GetAssetsUseCase {
  final AssetRepository repository;

  GetAssetsUseCase(this.repository);

  Future<List<Asset>> execute() async {
    return await repository.getAssets();
  }
}
