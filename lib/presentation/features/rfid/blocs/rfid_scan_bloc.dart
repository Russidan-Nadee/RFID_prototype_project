import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../domain/usecases/rfid/scan_rfid_usecase.dart';
import '../../../../core/services/rfid_service.dart';
import '../../../../data/datasources/local/mock_rfid_service.dart';

enum RfidScanStatus { initial, scanning, found, notFound, error }

class RfidScanBloc extends ChangeNotifier {
  final ScanRfidUseCase _scanRfidUseCase;
  final GetIt _getIt = GetIt.instance;
  MockRfidService? _mockRfidService;

  RfidScanStatus _status = RfidScanStatus.initial;
  String _errorMessage = '';
  String _lastScannedUid = '';

  // เพิ่มตัวแปรสำหรับโหมดการจำลอง

  RfidScanBloc(this._scanRfidUseCase) {
    // ดึง RFID Service จาก Dependency Injection
    // ตรวจสอบว่าเป็น MockRfidService หรือไม่
    final rfidService = _getIt<RfidService>();
    if (rfidService is MockRfidService) {
      _mockRfidService = rfidService;
    }
  }

  RfidScanStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get lastScannedUid => _lastScannedUid;

  // getter สำหรับโหมดการจำลอง
  MockMode get mockMode => _mockRfidService?.currentMode ?? MockMode.normal;

  // setter สำหรับโหมดการจำลอง
  set mockMode(MockMode mode) {
    if (_mockRfidService != null) {
      _mockRfidService!.setMockMode(mode);
      notifyListeners();
    }
  }

  // ตรวจสอบว่าใช้ Mock หรือไม่
  bool get isMockMode => _mockRfidService != null;

  // วิธีสแกน RFID จริง
  Future<void> scanRfid(BuildContext context) async {
    _status = RfidScanStatus.scanning;
    _errorMessage = '';
    notifyListeners();

    try {
      // เรียกใช้ UseCase สำหรับสแกน RFID
      final result = await _scanRfidUseCase.execute(context);

      _lastScannedUid = result['uid'] as String;

      if (result['found'] as bool) {
        _status = RfidScanStatus.found;
        // นำทางไปยังหน้าแสดงข้อมูลสินทรัพย์
        Navigator.pushNamed(
          context,
          '/foundPage', // ควรเป็น '/found' ตามที่กำหนดใน app_routes.dart
          arguments: {'asset': result['asset'], 'uid': _lastScannedUid},
        );
      } else {
        _status = RfidScanStatus.notFound;
        // นำทางไปยังหน้าไม่พบสินทรัพย์
        Navigator.pushNamed(
          context,
          '/notFoundPage', // ควรเป็น '/notFound' ตามที่กำหนดใน app_routes.dart
          arguments: {'uid': _lastScannedUid},
        );
      }
    } catch (e) {
      _status = RfidScanStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // วิธีจำลองการสแกนด้วย UID ที่กำหนดเอง
  Future<void> scanWithManualUid(String uid, BuildContext context) async {
    if (uid.isEmpty) {
      _errorMessage = 'Please enter a UID';
      notifyListeners();
      return;
    }

    _status = RfidScanStatus.scanning;
    _lastScannedUid = uid;
    _errorMessage = '';
    notifyListeners();

    try {
      // เรียกใช้ UseCase สำหรับสแกนด้วย UID ที่กำหนดเอง
      final result = await _scanRfidUseCase.executeWithUid(uid, context);

      if (result['found'] as bool) {
        _status = RfidScanStatus.found;
        // นำทางไปยังหน้าแสดงข้อมูลสินทรัพย์
        // แก้ไขการอ้างอิงเส้นทางการนำทาง
        Navigator.pushNamed(
          context,
          '/foundScreen', // แทน '/foundPage' - ไม่สอดคล้องกับเมธอด scanRfid และ app_routes.dart
          arguments: {'asset': result['asset'], 'uid': _lastScannedUid},
        );

        // และ - ปัญหาคือมีการนำทางไปทั้งสองหน้าโดยไม่มีเงื่อนไข
        Navigator.pushNamed(
          context,
          '/notFoundScreen', // แทน '/notFoundPage' - ไม่สอดคล้องกับเมธอด scanRfid และ app_routes.dart
          arguments: {'uid': _lastScannedUid},
        );
      }
    } catch (e) {
      _status = RfidScanStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  void resetStatus() {
    _status = RfidScanStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
