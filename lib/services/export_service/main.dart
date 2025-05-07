import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'api/controllers/export_controller.dart';
import 'api/routes/export_routes.dart';
import 'data/datasources/local/export_database.dart';
import 'data/datasources/remote/asset_service_client.dart';
import 'data/repositories/export_repository_impl.dart';
import 'domain/repositories/export_repository.dart';

void main() async {
  // สร้าง dependencies
  final exportDatabase = ExportDatabase();
  await exportDatabase.init();
  final assetServiceClient = AssetServiceClient();

  // สร้าง repository
  final ExportRepository exportRepository = ExportRepositoryImpl(
    exportDatabase,
    assetServiceClient,
  );

  // สร้าง controller
  final exportController = ExportController(exportRepository);

  // สร้าง router และกำหนด routes
  final router = Router();

  // ลงทะเบียน routes
  ExportRoutes(router, exportController).registerRoutes();

  // สร้าง handler พร้อม middleware
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // เริ่มต้น server
  final server = await io.serve(handler, '0.0.0.0', 8004);
  print(
    'Export Service เริ่มทำงานแล้วที่ http://${server.address.host}:${server.port}',
  );
}
