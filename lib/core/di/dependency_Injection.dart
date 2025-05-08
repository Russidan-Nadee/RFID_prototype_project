import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../configuration/app_config.dart';
import '../../services/asset_service/data/datasources/local/asset_database.dart';
import '../../services/asset_service/data/repositories/asset_repository_impl.dart';
import '../../services/asset_service/domain/repositories/asset_repository.dart';
import '../../services/dashboard_service/data/repositories/dashboard_repository_impl.dart';
import '../../services/dashboard_service/data/datasources/remote/asset_service_client.dart';
import '../../services/dashboard_service/data/datasources/remote/rfid_service_client.dart';
import '../../services/export_service/data/repositories/export_repository_impl.dart';
import '../../services/export_service/data/datasources/local/export_database.dart';
import '../../services/rfid_service/data/repositories/rfid_repository_impl.dart';
import '../../services/rfid_service/data/datasources/local/rfid_device_interface.dart';
import '../../services/rfid_service/data/datasources/remote/asset_service_client.dart'
    as rfid_asset_client;

class DependencyInjection {
  static final GetIt _locator = GetIt.instance;

  static Future<void> init() async {
    // ลงทะเบียน Http Client
    _locator.registerLazySingleton<Dio>(() => Dio());

    // ลงทะเบียน Databases
    final assetDatabase = AssetDatabase();
    await assetDatabase.init();
    _locator.registerSingleton<AssetDatabase>(assetDatabase);

    final exportDatabase = ExportDatabase();
    await exportDatabase.init();
    _locator.registerSingleton<ExportDatabase>(exportDatabase);

    // ลงทะเบียน Clients
    _locator.registerLazySingleton<AssetServiceClient>(
      () => AssetServiceClient(),
    );

    _locator.registerLazySingleton<RfidServiceClient>(
      () => RfidServiceClient(),
    );

    _locator.registerLazySingleton<rfid_asset_client.AssetServiceClient>(
      () => rfid_asset_client.AssetServiceClient(),
    );

    _locator.registerLazySingleton<MockRfidDeviceInterface>(
      () => MockRfidDeviceInterface(),
    );

    // ลงทะเบียน Repositories
    _locator.registerLazySingleton<AssetRepository>(
      () => AssetRepositoryImpl(_locator<AssetDatabase>()),
    );

    _locator.registerLazySingleton<DashboardRepositoryImpl>(
      () => DashboardRepositoryImpl(
        _locator<AssetServiceClient>(),
        _locator<RfidServiceClient>(),
      ),
    );

    _locator.registerLazySingleton<ExportRepositoryImpl>(
      () => ExportRepositoryImpl(
        _locator<ExportDatabase>(),
        _locator<AssetServiceClient>(),
      ),
    );

    _locator.registerLazySingleton<RfidRepositoryImpl>(
      () => RfidRepositoryImpl(
        _locator<MockRfidDeviceInterface>(),
        _locator<rfid_asset_client.AssetServiceClient>(),
      ),
    );

    // ลงทะเบียน Blocs/Controllers (stub ที่ยังไม่มีการสร้าง)
    // จะเพิ่มเติมเมื่อมีการสร้างคลาสจริง
  }

  static T get<T extends Object>() => _locator<T>();
}
