import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:rfid_project/services/asset_service/api/routes/asset_routes.dart';
import 'package:rfid_project/services/asset_service/data/repositories/asset_repository_impl.dart';
import 'package:rfid_project/services/asset_service/data/datasources/local/asset_database.dart';

// เพิ่ม class AppConfig สำหรับกำหนดค่าคงที่ของแอพพลิเคชัน
class AppConfig {
  // ค่าคงที่สำหรับชื่อแอพพลิเคชัน
  static const String appName = 'RFID Asset Management';

  // ค่าคงที่สำหรับเวอร์ชันแอพพลิเคชัน
  static const String appVersion = '1.0.0';

  // URL สำหรับบริการต่างๆ
  static const String assetServiceUrl = 'http://localhost:8001';
  static const String rfidServiceUrl = 'http://localhost:8002';
  static const String dashboardServiceUrl = 'http://localhost:8003';
  static const String exportServiceUrl = 'http://localhost:8004';

  // ตั้งค่า timeout สำหรับการเชื่อมต่อ API ในหน่วยมิลลิวินาที
  static const int apiTimeout = 10000;
}

// ฟังก์ชัน main ยังคงเหมือนเดิม
void main() async {
  // เริ่มต้นฐานข้อมูล
  final assetDatabase = AssetDatabase();
  await assetDatabase.init();

  // สร้าง repository
  final assetRepository = AssetRepositoryImpl(assetDatabase);

  // สร้าง router และกำหนด routes
  final router = Router();

  // ลงทะเบียน routes
  AssetRoutes(router, assetRepository).registerRoutes();

  // สร้าง handler พร้อม middleware
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // เริ่มต้น server
  final server = await io.serve(handler, '0.0.0.0', 8001);
  print(
    'Asset Service เริ่มทำงานแล้วที่ http://${server.address.host}:${server.port}',
  );
}
