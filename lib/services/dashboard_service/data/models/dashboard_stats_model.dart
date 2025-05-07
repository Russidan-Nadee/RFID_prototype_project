import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  DashboardStatsModel({
    required int totalAssets,
    required int checkedInAssets,
    required int availableAssets,
    required int rfidScansToday,
    required int pendingExports,
    required DateTime lastUpdated,
  }) : super(
         totalAssets: totalAssets,
         checkedInAssets: checkedInAssets,
         availableAssets: availableAssets,
         rfidScansToday: rfidScansToday,
         pendingExports: pendingExports,
         lastUpdated: lastUpdated,
       );

  factory DashboardStatsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatsModel(
      totalAssets: map['totalAssets'] ?? 0,
      checkedInAssets: map['checkedInAssets'] ?? 0,
      availableAssets: map['availableAssets'] ?? 0,
      rfidScansToday: map['rfidScansToday'] ?? 0,
      pendingExports: map['pendingExports'] ?? 0,
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAssets': totalAssets,
      'checkedInAssets': checkedInAssets,
      'availableAssets': availableAssets,
      'rfidScansToday': rfidScansToday,
      'pendingExports': pendingExports,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DashboardStatsModel.fromEntity(DashboardStats entity) {
    return DashboardStatsModel(
      totalAssets: entity.totalAssets,
      checkedInAssets: entity.checkedInAssets,
      availableAssets: entity.availableAssets,
      rfidScansToday: entity.rfidScansToday,
      pendingExports: entity.pendingExports,
      lastUpdated: entity.lastUpdated,
    );
  }
}
