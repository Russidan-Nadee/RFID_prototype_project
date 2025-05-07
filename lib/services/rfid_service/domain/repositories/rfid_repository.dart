import '../entities/rfid_scan.dart';

abstract class RfidRepository {
  Future<RfidScan> scanRfid();
  Future<RfidScan> mockScanRfid(bool shouldFind);
  Future<bool> isDeviceAvailable();
  bool isScanning();
  void stopScan();
  Future<void> setMockMode(String mode);
  String getCurrentMockMode();
}
