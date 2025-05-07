import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../domain/entities/asset.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../domain/usecases/get_assets_usecase.dart';
import '../../domain/usecases/search_asset_usecase.dart';
import '../../domain/usecases/update_asset_usecase.dart';

/// คอนโทรลเลอร์สำหรับจัดการ API ของสินทรัพย์
class AssetController {
  final AssetRepository _repository;
  final GetAssetsUseCase _getAssetsUseCase;
  final SearchAssetUseCase _searchAssetUseCase;
  final UpdateAssetUseCase _updateAssetUseCase;

  AssetController(this._repository)
    : _getAssetsUseCase = GetAssetsUseCase(_repository),
      _searchAssetUseCase = SearchAssetUseCase(_repository),
      _updateAssetUseCase = UpdateAssetUseCase(_repository);

  /// ดึงรายการสินทรัพย์ทั้งหมด
  Future<Response> getAssets(Request request) async {
    try {
      final assets = await _getAssetsUseCase.execute();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': assets.map((a) => _assetToJson(a)).toList(),
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// ดึงข้อมูลสินทรัพย์จาก UID
  Future<Response> getAssetByUid(Request request, String uid) async {
    try {
      final asset = await _searchAssetUseCase.execute(uid);

      if (asset == null) {
        return Response.notFound(
          jsonEncode({
            'success': false,
            'message': 'ไม่พบสินทรัพย์ที่มี UID: $uid',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'success': true, 'data': _assetToJson(asset)}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// เพิ่มสินทรัพย์ใหม่
  Future<Response> createAsset(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonData);

      // ตรวจสอบข้อมูลที่จำเป็น
      final requiredFields = ['id', 'category', 'brand', 'uid', 'department'];
      for (final field in requiredFields) {
        if (data[field] == null || data[field].toString().isEmpty) {
          return Response.badRequest(
            body: jsonEncode({'success': false, 'message': 'กรุณาระบุ $field'}),
            headers: {'content-type': 'application/json'},
          );
        }
      }

      final asset = Asset(
        id: data['id'],
        category: data['category'],
        status: data['status'] ?? 'Available',
        brand: data['brand'],
        uid: data['uid'],
        department: data['department'],
        date: data['date'] ?? DateTime.now().toString().split(' ')[0],
      );

      await _repository.insertAsset(asset);

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'เพิ่มสินทรัพย์สำเร็จ',
          'data': _assetToJson(asset),
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// อัปเดตสถานะสินทรัพย์
  Future<Response> updateAssetStatus(Request request, String uid) async {
    try {
      final jsonData = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonData);

      final status = data['status'];
      if (status == null || status.toString().isEmpty) {
        return Response.badRequest(
          body: jsonEncode({'success': false, 'message': 'กรุณาระบุสถานะ'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final success = await _updateAssetUseCase.updateStatus(uid, status);

      if (!success) {
        return Response.notFound(
          jsonEncode({
            'success': false,
            'message': 'ไม่พบสินทรัพย์ที่มี UID: $uid',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'success': true, 'message': 'อัปเดตสถานะสินทรัพย์สำเร็จ'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// อัปเดตข้อมูลสินทรัพย์ทั้งหมด
  Future<Response> updateAsset(Request request) async {
    try {
      final jsonData = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonData);

      final uid = data['uid'];
      if (uid == null || uid.toString().isEmpty) {
        return Response.badRequest(
          body: jsonEncode({'success': false, 'message': 'กรุณาระบุ UID'}),
          headers: {'content-type': 'application/json'},
        );
      }

      // ตรวจสอบว่ามีสินทรัพย์นี้อยู่หรือไม่
      final existingAsset = await _searchAssetUseCase.execute(uid);
      if (existingAsset == null) {
        return Response.notFound(
          jsonEncode({
            'success': false,
            'message': 'ไม่พบสินทรัพย์ที่มี UID: $uid',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // สร้างสินทรัพย์ใหม่โดยอัปเดตข้อมูลจากของเดิม
      final asset = Asset(
        id: data['id'] ?? existingAsset.id,
        category: data['category'] ?? existingAsset.category,
        status: data['status'] ?? existingAsset.status,
        brand: data['brand'] ?? existingAsset.brand,
        uid: uid,
        department: data['department'] ?? existingAsset.department,
        date: data['date'] ?? existingAsset.date,
      );

      final updatedAsset = await _updateAssetUseCase.execute(asset);

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'อัปเดตสินทรัพย์สำเร็จ',
          'data': updatedAsset != null ? _assetToJson(updatedAsset) : null,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// ลบสินทรัพย์
  Future<Response> deleteAsset(Request request, String uid) async {
    try {
      // ตรวจสอบว่ามีสินทรัพย์นี้อยู่หรือไม่
      final asset = await _searchAssetUseCase.execute(uid);
      if (asset == null) {
        return Response.notFound(
          jsonEncode({
            'success': false,
            'message': 'ไม่พบสินทรัพย์ที่มี UID: $uid',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      await _repository.deleteAsset(uid);

      return Response.ok(
        jsonEncode({'success': true, 'message': 'ลบสินทรัพย์สำเร็จ'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// ลบสินทรัพย์ทั้งหมด
  Future<Response> deleteAllAssets(Request request) async {
    try {
      await _repository.deleteAllAssets();

      return Response.ok(
        jsonEncode({'success': true, 'message': 'ลบสินทรัพย์ทั้งหมดสำเร็จ'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// ดึงรายการหมวดหมู่
  Future<Response> getCategories(Request request) async {
    try {
      final categories = await _repository.getCategories();

      return Response.ok(
        jsonEncode({'success': true, 'data': categories}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// ดึง UID แบบสุ่ม
  Future<Response> getRandomUid(Request request) async {
    try {
      final uid = await _repository.getRandomUid();

      if (uid == null) {
        return Response.ok(
          jsonEncode({'success': false, 'message': 'ไม่พบสินทรัพย์ในระบบ'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {'uid': uid},
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'message': 'เกิดข้อผิดพลาด: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  /// แปลงข้อมูล Asset เป็น JSON
  Map<String, dynamic> _assetToJson(Asset asset) {
    return {
      'id': asset.id,
      'category': asset.category,
      'status': asset.status,
      'brand': asset.brand,
      'uid': asset.uid,
      'department': asset.department,
      'date': asset.date,
    };
  }
}
