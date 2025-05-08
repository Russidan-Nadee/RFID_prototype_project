import 'package:rfid_project/services/export_service/data/datasources/remote/asset_service_client.dart';

import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/remote/rfid_service_client.dart';
import '../models/dashboard_stats_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final AssetServiceClient _assetServiceClient;
  final RfidServiceClient _rfidServiceClient;

  DashboardRepositoryImpl(this._assetServiceClient, this._rfidServiceClient);

  @override
  Future<DashboardStats> getDashboardStats() async {
    try {
      // ดึงข้อมูลสินทรัพย์ทั้งหมด
      final assets = await _assetServiceClient.getAssets();

      // นับจำนวนสินทรัพย์ตามสถานะ
      int totalAssets = assets.length;
      int checkedInAssets =
          assets.where((asset) => asset['status'] == 'Checked In').length;
      int availableAssets =
          assets.where((asset) => asset['status'] == 'Available').length;

      // ดึงจำนวนการสแกน RFID วันนี้
      int rfidScansToday = await _rfidServiceClient.getScanCountToday();

      // สมมติว่ามีการส่งออกที่รอดำเนินการ 0 รายการ
      int pendingExports = 0;

      return DashboardStatsModel(
        totalAssets: totalAssets,
        checkedInAssets: checkedInAssets,
        availableAssets: availableAssets,
        rfidScansToday: rfidScansToday,
        pendingExports: pendingExports,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get dashboard stats: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCategoryDistribution() async {
    try {
      // ดึงข้อมูลสินทรัพย์ทั้งหมด
      final assets = await _assetServiceClient.getAssets();

      // นับจำนวนสินทรัพย์ตามหมวดหมู่
      final Map<String, int> categoryCount = {};

      for (var asset in assets) {
        final category = asset['category'] as String;
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }

      return {
        'categories': categoryCount.keys.toList(),
        'counts': categoryCount.values.toList(),
      };
    } catch (e) {
      throw Exception('Failed to get category distribution: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getDepartmentDistribution() async {
    try {
      // ดึงข้อมูลสินทรัพย์ทั้งหมด
      final assets = await _assetServiceClient.getAssets();

      // นับจำนวนสินทรัพย์ตามแผนก
      final Map<String, int> departmentCount = {};

      for (var asset in assets) {
        final department = asset['department'] as String;
        departmentCount[department] = (departmentCount[department] ?? 0) + 1;
      }

      return {
        'departments': departmentCount.keys.toList(),
        'counts': departmentCount.values.toList(),
      };
    } catch (e) {
      throw Exception('Failed to get department distribution: $e');
    }
  }

  @override
  Future<Map<String, int>> getScanHistoryByDay() async {
    try {
      return await _rfidServiceClient.getScanHistoryByDay();
    } catch (e) {
      throw Exception('Failed to get scan history: $e');
    }
  }
}
