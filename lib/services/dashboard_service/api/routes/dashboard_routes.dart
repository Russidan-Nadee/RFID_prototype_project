import 'package:shelf_router/shelf_router.dart';
import '../controllers/dashboard_controller.dart';

class DashboardRoutes {
  final Router _router;
  final DashboardController _controller;

  DashboardRoutes(this._router, this._controller);

  void registerRoutes() {
    // เส้นทางสำหรับ Dashboard
    _router.get('/dashboard/stats', _controller.getDashboardStats);
    _router.get(
      '/dashboard/category-distribution',
      _controller.getCategoryDistribution,
    );
    _router.get(
      '/dashboard/department-distribution',
      _controller.getDepartmentDistribution,
    );
    _router.get('/dashboard/scan-history', _controller.getScanHistoryByDay);
  }
}
