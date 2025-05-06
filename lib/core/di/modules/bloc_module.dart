// ไฟล์นี้ลงทะเบียน Bloc ทั้งหมดที่ใช้ในแอปพลิเคชัน

import 'package:get_it/get_it.dart';
import 'package:rfid_project/domain/usecases/assets/get_assets_usecase.dart';
import 'package:rfid_project/domain/usecases/cartegory/add_category_usecase.dart';
import 'package:rfid_project/domain/usecases/cartegory/delete_category_usecase.dart';
import 'package:rfid_project/domain/usecases/cartegory/get_categories_usecase.dart';
import 'package:rfid_project/domain/usecases/cartegory/update_category_usecase.dart';
import 'package:rfid_project/domain/usecases/rfid/get_random_uid_usecase.dart';
import 'package:rfid_project/domain/usecases/rfid/scan_rfid_usecase.dart';
import 'package:rfid_project/domain/repositories/asset_repository.dart';
import 'package:rfid_project/presentation/features/assets/blocs/asset_bloc.dart';
import 'package:rfid_project/presentation/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:rfid_project/presentation/features/export/blocs/export_bloc.dart';
import 'package:rfid_project/presentation/features/main/blocs/navigation_bloc.dart';
import 'package:rfid_project/presentation/features/rfid/blocs/rfid_scan_bloc.dart';
import 'package:rfid_project/presentation/features/settings/blocs/settings_bloc.dart';
import 'package:rfid_project/presentation/features/settings/blocs/category_bloc.dart';

class BlocModule {
  // สร้างตัวแปรเพื่อเข้าถึงตัวจัดการการเชื่อมโยง (GetIt)
  final GetIt _getIt = GetIt.instance;

  // ฟังก์ชันลงทะเบียน Bloc ทั้งหมด
  Future<void> register() async {
    // ลงทะเบียน NavigationBloc
    _getIt.registerFactory(() => NavigationBloc());

    // ลงทะเบียน AssetBloc
    _getIt.registerFactory(() => AssetBloc(_getIt<GetAssetsUseCase>()));

    // ลงทะเบียน DashboardBloc
    _getIt.registerFactory(() => DashboardBloc(_getIt<GetAssetsUseCase>()));

    // ลงทะเบียน ExportBloc
    _getIt.registerFactory(() => ExportBloc(_getIt<GetAssetsUseCase>()));

    // ลงทะเบียน RfidScanBloc
    _getIt.registerFactory(
      () => RfidScanBloc(
        _getIt<ScanRfidUseCase>(),
        _getIt<GetRandomUidUseCase>(), // เพิ่มพารามิเตอร์ตัวที่ 2
      ),
    );

    // ลงทะเบียน SettingsBloc
    _getIt.registerFactory(() => SettingsBloc(_getIt<AssetRepository>()));

    // ลงทะเบียน CategoryBloc
    _getIt.registerFactory(
      () => CategoryBloc(
        _getIt<GetCategoriesUseCase>(),
        _getIt<AddCategoryUseCase>(),
        _getIt<UpdateCategoryUseCase>(),
        _getIt<DeleteCategoryUseCase>(),
      ),
    );
  }
}
