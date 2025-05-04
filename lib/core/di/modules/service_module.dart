// ไฟล์นี้ลงทะเบียนบริการต่างๆ ที่ใช้ในการจัดการธุรกิจของแอป (เรียกว่า UseCase)

// นำเข้าไลบรารี get_it สำหรับจัดการการเชื่อมโยงส่วนต่างๆ ในแอป
import 'package:get_it/get_it.dart';
import 'package:rfid_project/core/services/rfid_service.dart';
import 'package:rfid_project/data/datasources/local/mock_rfid_service.dart';
import 'package:rfid_project/domain/usecases/assets/get_assets_usecase.dart';
import 'package:rfid_project/domain/usecases/assets/search_asset_usecase.dart';
import 'package:rfid_project/domain/usecases/assets/update_asset_usecase.dart';
import 'package:rfid_project/domain/usecases/rfid/scan_rfid_usecase.dart';

// คลาสโมดูลบริการ - ใช้ลงทะเบียนการทำงานระดับสูง (UseCase) ในแอป
class ServiceModule {
  // สร้างตัวแปรเพื่อเข้าถึงตัวจัดการการเชื่อมโยง (GetIt)
  final GetIt _getIt = GetIt.instance;

  // ฟังก์ชันลงทะเบียนบริการต่างๆ
  Future<void> register() async {
    // ลงทะเบียน RFID Service (Mock)
    _getIt.registerLazySingleton<RfidService>(() => MockRfidService());

    // ลงทะเบียน UseCase ต่างๆ

    // ลงทะเบียน UseCase สำหรับสแกน RFID
    _getIt.registerLazySingleton(() => ScanRfidUseCase(_getIt(), _getIt()));

    // ลงทะเบียน UseCase สำหรับดึงข้อมูลสินทรัพย์ทั้งหมด
    // _getIt() ดึงคลังข้อมูล (repository) ที่ลงทะเบียนไว้แล้วมาใช้
    _getIt.registerLazySingleton(() => GetAssetsUseCase(_getIt()));

    // ลงทะเบียน UseCase สำหรับค้นหาสินทรัพย์
    // _getIt() ดึงคลังข้อมูล (repository) ที่ลงทะเบียนไว้แล้วมาใช้
    _getIt.registerLazySingleton(() => SearchAssetUseCase(_getIt()));

    // ลงทะเบียน UseCase สำหรับอัปเดตข้อมูลสินทรัพย์
    // _getIt() ดึงคลังข้อมูล (repository) ที่ลงทะเบียนไว้แล้วมาใช้
    _getIt.registerLazySingleton(() => UpdateAssetUseCase(_getIt()));
  }
}
