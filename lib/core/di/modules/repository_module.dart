import 'package:get_it/get_it.dart';
import '../../../data/repositories/asset_repository_impl.dart';
import '../../../domain/repositories/asset_repository.dart';

class RepositoryModule {
  final GetIt _getIt = GetIt.instance;

  Future<void> register() async {
    _getIt.registerLazySingleton<AssetRepository>(
      () => AssetRepositoryImpl(_getIt()),
    );
  }
}
