import '../entities/rfid_scan.dart';
import '../repositories/rfid_repository.dart';

class ScanRfidUseCase {
  final RfidRepository _repository;

  ScanRfidUseCase(this._repository);

  Future<RfidScan> execute() async {
    if (!await _repository.isDeviceAvailable()) {
      throw Exception('RFID device is not available');
    }

    return await _repository.scanRfid();
  }

  Future<RfidScan> mockScan(bool shouldFind) async {
    return await _repository.mockScanRfid(shouldFind);
  }
}
