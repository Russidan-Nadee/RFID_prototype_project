import 'package:get_it/get_it.dart';
import '../modules/database_module.dart';
import '../modules/repository_module.dart';
import '../modules/service_module.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // Register modules
    await DatabaseModule().register();
    await RepositoryModule().register();
    await ServiceModule().register();
  }
}
