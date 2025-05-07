import '../entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getDashboardStats();
  Future<Map<String, dynamic>> getCategoryDistribution();
  Future<Map<String, dynamic>> getDepartmentDistribution();
  Future<Map<String, int>> getScanHistoryByDay();
}
