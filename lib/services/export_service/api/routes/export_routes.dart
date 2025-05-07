import 'package:shelf_router/shelf_router.dart';
import '../controllers/export_controller.dart';

class ExportRoutes {
  final Router _router;
  final ExportController _controller;

  ExportRoutes(this._router, this._controller);

  void registerRoutes() {
    // เส้นทางสำหรับการส่งออก
    _router.get('/exports', _controller.getExportHistory);
    _router.post('/exports', _controller.exportAssets);
    _router.get('/exports/<id>', _controller.downloadExport);
    _router.delete('/exports/<id>', _controller.deleteExport);
  }
}
