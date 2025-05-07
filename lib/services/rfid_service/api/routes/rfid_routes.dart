import 'package:shelf_router/shelf_router.dart';
import '../controllers/rfid_controller.dart';

class RfidRoutes {
  final Router _router;
  final RfidController _controller;

  RfidRoutes(this._router, this._controller);

  void registerRoutes() {
    // เส้นทางสำหรับ RFID
    _router.post('/rfid/scan', _controller.scanRfid);
    _router.post('/rfid/mock-scan', _controller.mockScanRfid);
    _router.get('/rfid/status', _controller.checkDeviceStatus);
    _router.post('/rfid/mock-mode', _controller.setMockMode);
    _router.get('/rfid/mock-mode', _controller.getMockMode);
  }
}
