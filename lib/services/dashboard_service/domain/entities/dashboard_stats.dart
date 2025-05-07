class DashboardStats {
  final int totalAssets;
  final int checkedInAssets;
  final int availableAssets;
  final int rfidScansToday;
  final int pendingExports;
  final DateTime lastUpdated;

  DashboardStats({
    required this.totalAssets,
    required this.checkedInAssets,
    required this.availableAssets,
    required this.rfidScansToday,
    required this.pendingExports,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalAssets': totalAssets,
      'checkedInAssets': checkedInAssets,
      'availableAssets': availableAssets,
      'rfidScansToday': rfidScansToday,
      'pendingExports': pendingExports,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalAssets: json['totalAssets'] ?? 0,
      checkedInAssets: json['checkedInAssets'] ?? 0,
      availableAssets: json['availableAssets'] ?? 0,
      rfidScansToday: json['rfidScansToday'] ?? 0,
      pendingExports: json['pendingExports'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
