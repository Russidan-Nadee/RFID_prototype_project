import 'package:get_it/get_it.dart';
import '../../../domain/usecases/get_assets_usecase.dart';
import '../../../domain/usecases/search_asset_usecase.dart';
import '../../../domain/usecases/update_asset_usecase.dart';

class ServiceModule {
  final GetIt _getIt = GetIt.instance;

  Future<void> register() async {
    // Register use cases
    _getIt.registerLazySingleton(() => GetAssetsUseCase(_getIt()));
    _getIt.registerLazySingleton(() => SearchAssetUseCase(_getIt()));
    _getIt.registerLazySingleton(() => UpdateAssetUseCase(_getIt()));
  }
}
