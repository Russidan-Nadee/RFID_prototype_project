import 'package:flutter/material.dart';
import '../../../../domain/usecases/rfid/scan_rfid_usecase.dart';

enum RfidScanStatus { initial, scanning, found, notFound, error }

class RfidScanBloc extends ChangeNotifier {
  final ScanRfidUseCase _scanRfidUseCase;

  RfidScanStatus _status = RfidScanStatus.initial;
  String _errorMessage = '';
  bool _wantToFind = true;

  RfidScanBloc(this._scanRfidUseCase);

  RfidScanStatus get status => _status;
  String get errorMessage => _errorMessage;

  // กำหนดว่าต้องการเจอสินทรัพย์หรือไม่
  void setFindPreference(bool wantToFind) {
    _wantToFind = wantToFind;
  }

  // ดำเนินการสแกน
  Future<void> performScan(BuildContext context) async {
    _status = RfidScanStatus.scanning;
    _errorMessage = '';
    notifyListeners();

    try {
      if (_wantToFind) {
        // กรณีต้องการเจอสินทรัพย์
        _status = RfidScanStatus.found;
        notifyListeners();

        // นำทางไปยังหน้าพบสินทรัพย์ โดยส่งพารามิเตอร์น้อยที่สุด
        Navigator.of(
          context,
        ).pushNamed('/found', arguments: {'uid': 'TEST-UID-123'});
      } else {
        // กรณีไม่ต้องการเจอสินทรัพย์
        _status = RfidScanStatus.notFound;
        notifyListeners();

        // นำทางไปยังหน้าไม่พบสินทรัพย์
        Navigator.of(
          context,
        ).pushNamed('/notFound', arguments: {'uid': 'TEST-UID-NOT-FOUND'});
      }
    } catch (e) {
      _status = RfidScanStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void resetStatus() {
    _status = RfidScanStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
