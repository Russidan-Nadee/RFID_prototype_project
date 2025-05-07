import 'package:rfid_project/services/asset_service/api/routes/asset_routes.dart';
import 'package:rfid_project/services/asset_service/data/datasources/local/asset_database.dart';
import 'package:rfid_project/services/asset_service/data/repositories/asset_repository_impl.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

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
