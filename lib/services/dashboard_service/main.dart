import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'api/controllers/dashboard_controller.dart';
import 'api/routes/dashboard_routes.dart';
import 'data/datasources/remote/asset_service_client.dart';
import 'data/datasources/remote/rfid_service_client.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'domain/repositories/dashboard_repository.dart';

void main() async {
  // สร้าง dependencies
  final assetServiceClient = AssetServiceClient();
  final rfidServiceClient = RfidServiceClient();

  // สร้าง repository
  final DashboardRepository dashboardRepository = DashboardRepositoryImpl(
    assetServiceClient,
    rfidServiceClient,
  );

  // สร้าง controller
  final dashboardController = DashboardController(dashboardRepository);

  // สร้าง router และกำหนด routes
  final router = Router();

  // ลงทะเบียน routes
  DashboardRoutes(router, dashboardController).registerRoutes();

  // สร้าง handler พร้อม middleware
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // เริ่มต้น server
  final server = await io.serve(handler, '0.0.0.0', 8003);
  print(
    'Dashboard Service เริ่มทำงานแล้วที่ http://${server.address.host}:${server.port}',
  );
}
