import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'api/controllers/asset_controller.dart';
import 'api/routes/asset_routes.dart';
import 'data/datasources/local/asset_database.dart';
import 'data/repositories/asset_repository_impl.dart';

void main() async {
  // เริ่มต้นฐานข้อมูล
  final assetDatabase = AssetDatabase();
  await assetDatabase.init();

  // สร้าง repository
  final assetRepository = AssetRepositoryImpl(assetDatabase);

  // สร้าง controller
  final assetController = AssetController(assetRepository);

  // สร้าง router และกำหนด routes
  final router = Router();

  // ลงทะเบียน routes
  AssetRoutes(router, assetController).registerRoutes();

  // สร้าง handler พร้อม middleware
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // เริ่มต้น server
  final server = await io.serve(handler, '0.0.0.0', 8001);
  print(
    'Asset Service เริ่มทำงานแล้วที่ http://${server.address.host}:${server.port}',
  );
}
