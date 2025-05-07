import 'package:rfid_project/waitforedit/domain/repositories/asset_repository.dart';

class AddCategoryUseCase {
  final AssetRepository repository;

  AddCategoryUseCase(this.repository);

  Future<void> execute(String name) async {
    await repository.addCategory(name);
  }
}
