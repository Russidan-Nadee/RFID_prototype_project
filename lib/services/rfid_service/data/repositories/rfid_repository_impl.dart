import '../../domain/entities/rfid_scan.dart';
import '../../domain/repositories/rfid_repository.dart';
import '../datasources/local/rfid_device_interface.dart';
import '../datasources/remote/asset_service_client.dart';
import '../models/rfid_scan_model.dart';

class RfidRepositoryImpl implements RfidRepository {
  final RfidDeviceInterface _rfidDevice;
  final AssetServiceClient _assetServiceClient;

  RfidRepositoryImpl(this._rfidDevice, this._assetServiceClient);

  @override
  Future<RfidScan> scanRfid() async {
    final uid = await _rfidDevice.scanRfid();

    if (uid == null) {
      throw Exception('RFID scan failed');
    }

    final isFound = await _assetServiceClient.checkAssetExists(uid);

    return RfidScanModel(uid: uid, scanTime: DateTime.now(), isFound: isFound);
  }

  @override
  Future<RfidScan> mockScanRfid(bool shouldFind) async {
    // ตั้งค่าโหมดการจำลองตามที่ต้องการ
    _rfidDevice.setMockMode(shouldFind ? MockMode.found : MockMode.notFound);

    // ดำเนินการสแกนจำลอง
    final uid = await _rfidDevice.scanRfid();

    if (uid == null) {
      throw Exception('RFID scan failed');
    }

    return RfidScanModel(
      uid: uid,
      scanTime: DateTime.now(),
      isFound: shouldFind,
    );
  }

  @override
  Future<bool> isDeviceAvailable() async {
    return _rfidDevice.isAvailable();
  }

  @override
  bool isScanning() {
    return _rfidDevice.isScanning();
  }

  @override
  void stopScan() {
    _rfidDevice.stopScan();
  }

  @override
  Future<void> setMockMode(String mode) async {
    switch (mode) {
      case 'found':
        _rfidDevice.setMockMode(MockMode.found);
        break;
      case 'notFound':
        _rfidDevice.setMockMode(MockMode.notFound);
        break;
      case 'scanFailed':
        _rfidDevice.setMockMode(MockMode.scanFailed);
        break;
      default:
        _rfidDevice.setMockMode(MockMode.normal);
    }
  }

  @override
  String getCurrentMockMode() {
    switch (_rfidDevice.getCurrentMode()) {
      case MockMode.found:
        return 'found';
      case MockMode.notFound:
        return 'notFound';
      case MockMode.scanFailed:
        return 'scanFailed';
      default:
        return 'normal';
    }
  }
}
