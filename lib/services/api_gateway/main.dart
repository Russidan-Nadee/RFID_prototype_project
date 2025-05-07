import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'controllers/api_controller.dart';
import 'controllers/auth_controller.dart';
import 'middleware/auth_middleware.dart';
import 'middleware/logging_middleware.dart';
import 'routes/api_routes.dart';
import 'routes/route_configurator.dart';

void main() async {
  // สร้าง controllers
  final apiController = ApiController();
  final authController = AuthController();

  // สร้าง router
  final router = Router();

  // ลงทะเบียน routes
  final routeConfigurator = RouteConfigurator(router);
  ApiRoutes(routeConfigurator, apiController, authController).registerRoutes();

  // สร้าง middleware
  final authMiddleware = AuthMiddleware();
  final loggingMiddleware = LoggingMiddleware();

  // สร้าง handler พร้อม middleware
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(loggingMiddleware.handle)
      .addMiddleware(authMiddleware.handle)
      .addHandler(router);

  // เริ่มต้น server
  final server = await io.serve(handler, '0.0.0.0', 8000);
  print(
    'API Gateway เริ่มทำงานแล้วที่ http://${server.address.host}:${server.port}',
  );
}
