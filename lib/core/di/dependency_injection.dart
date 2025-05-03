import 'package:get_it/get_it.dart';
import 'package:rfid_project/core/di/modules/database_module.dart';
import 'package:rfid_project/core/di/modules/repository_module.dart';
import 'package:rfid_project/core/di/modules/service_module.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // Register modules
    await DatabaseModule().register();
    await RepositoryModule().register();
    await ServiceModule().register();
  }
}
