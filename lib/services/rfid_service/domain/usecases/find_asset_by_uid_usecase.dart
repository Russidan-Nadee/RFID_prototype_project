import '../repositories/rfid_repository.dart';

class FindAssetByUidUseCase {
  final RfidRepository _repository;

  FindAssetByUidUseCase(this._repository);

  Future<Map<String, dynamic>> execute(String uid) async {
    try {
      // สแกน RFID แล้วค้นหาข้อมูลสินทรัพย์
      final scan = await _repository.mockScanRfid(true);

      return {
        'uid': scan.uid,
        'isFound': scan.isFound,
        'scanTime': scan.scanTime.toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to find asset: $e');
    }
  }
}
