import 'package:shelf_router/shelf_router.dart';
import '../controllers/asset_controller.dart';
import '../../domain/repositories/asset_repository.dart';

class AssetRoutes {
  final Router _router;
  final AssetController _controller;

  // แก้ไขคอนสตรักเตอร์เพื่อรับ AssetRepository แทน AssetController
  // สร้าง AssetController ภายในคลาส
  AssetRoutes(this._router, AssetRepository repository)
    : _controller = AssetController(repository);

  void registerRoutes() {
    // เส้นทางสำหรับสินทรัพย์
    _router.get('/assets', _controller.getAssets);
    _router.get('/assets/<uid>', _controller.getAssetByUid);
    _router.post('/assets', _controller.createAsset);
    _router.put('/assets/<uid>/status', _controller.updateAssetStatus);
    _router.put('/assets', _controller.updateAsset);
    _router.delete('/assets/<uid>', _controller.deleteAsset);
    _router.delete('/assets', _controller.deleteAllAssets);

    // เส้นทางสำหรับหมวดหมู่
    _router.get('/categories', _controller.getCategories);

    // เส้นทางอื่นๆ
    _router.get('/random-uid', _controller.getRandomUid);
  }
}
