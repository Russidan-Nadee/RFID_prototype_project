import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository _repository;

  GetDashboardStatsUseCase(this._repository);

  Future<DashboardStats> execute() async {
    return await _repository.getDashboardStats();
  }
}
