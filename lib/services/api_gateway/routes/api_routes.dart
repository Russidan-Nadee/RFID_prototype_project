import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/api_controller.dart';
import '../controllers/auth_controller.dart';
import 'route_configurator.dart';

class ApiRoutes {
  final RouteConfigurator _configurator;
  final ApiController _apiController;
  final AuthController _authController;

  ApiRoutes(this._configurator, this._apiController, this._authController);

  void registerRoutes() {
    // เส้นทางสำหรับการตรวจสอบตัวตน
    _configurator.post('/auth/login', _authController.login);
    _configurator.post('/auth/logout', _authController.logout);
    _configurator.get('/auth/profile', _authController.getProfile);

    // เส้นทางสำหรับสินทรัพย์
    _configurator.get('/assets', _apiController.getAssets);
    _configurator.get('/assets/:uid', (Request request) {
      final params = request.params;
      final uid = params['uid'] ?? '';
      return _apiController.getAssetByUid(request, uid);
    });
    _configurator.post('/assets', _apiController.createAsset);
    _configurator.put('/assets', _apiController.updateAsset);
    _configurator.put('/assets/:uid/status', (Request request) {
      final params = request.params;
      final uid = params['uid'] ?? '';
      return _apiController.updateAssetStatus(request, uid);
    });
    _configurator.delete('/assets/:uid', (Request request) {
      final params = request.params;
      final uid = params['uid'] ?? '';
      return _apiController.deleteAsset(request, uid);
    });

    // เส้นทางสำหรับ RFID
    _configurator.post('/rfid/scan', _apiController.scanRfid);

    // เส้นทางสำหรับ Dashboard
    _configurator.get('/dashboard/stats', _apiController.getDashboardStats);

    // เส้นทางสำหรับการส่งออก
    _configurator.post('/exports', _apiController.exportAssets);
    _configurator.get('/exports/:id', (Request request) {
      final params = request.params;
      final id = params['id'] ?? '';
      return _apiController.downloadExport(request, id);
    });
  }
}
