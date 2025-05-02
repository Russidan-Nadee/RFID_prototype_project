import 'package:get_it/get_it.dart';
import '../../../data/datasources/local/database_helper.dart';

class DatabaseModule {
  final GetIt _getIt = GetIt.instance;

  Future<void> register() async {
    _getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  }
}
