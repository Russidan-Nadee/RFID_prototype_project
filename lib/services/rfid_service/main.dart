import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'api/controllers/rfid_controller.dart';
import 'api/routes/rfid_routes.dart';
import 'data/datasources/local/rfid_device_interface.dart';
import 'data/datasources/remote/asset_service_client.dart';
import 'data/repositories/rfid_repository_impl.dart';
import 'domain/repositories/rfid_repository.dart';

void main() async {
  // สร้าง dependencies
  final rfidDeviceInterface = MockRfidDeviceInterface();
  final assetServiceClient = AssetServiceClient();

  // สร้าง repository
  final RfidRepository rfidRepository = RfidRepositoryImpl(
    rfidDeviceInterface,
    assetServiceClient,
  );

  // สร้าง controller
  final rfidController = RfidController(rfidRepository);

  // สร้าง router และกำหนด routes
  final router = Router();

  // ลงทะเบียน routes
  RfidRoutes(router, rfidController).registerRoutes();

  // สร้าง handler พร้อม middleware
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // เริ่มต้น server
  final server = await io.serve(handler, '0.0.0.0', 8002);
  print(
    'RFID Service เริ่มทำงานแล้วที่ http://${server.address.host}:${server.port}',
  );
}
