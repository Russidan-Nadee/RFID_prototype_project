import 'package:flutter/material.dart';
import '../../../../domain/usecases/rfid/scan_rfid_usecase.dart';
import '../../../../domain/usecases/rfid/get_random_uid_usecase.dart'; // เพิ่ม import

enum RfidScanStatus { initial, scanning, found, notFound, error }

class RfidScanBloc extends ChangeNotifier {
  final ScanRfidUseCase _scanRfidUseCase;
  final GetRandomUidUseCase _getRandomUidUseCase; // เพิ่มตัวแปร

  RfidScanStatus _status = RfidScanStatus.initial;
  String _errorMessage = '';
  bool _wantToFind = true;
  String? _lastScannedUid; // เพิ่มตัวแปรเก็บ UID ล่าสุด

  // ปรับ constructor เพื่อรับ usecase เพิ่ม
  RfidScanBloc(this._scanRfidUseCase, this._getRandomUidUseCase);

  RfidScanStatus get status => _status;
  String get errorMessage => _errorMessage;
  String? get lastScannedUid => _lastScannedUid; // เพิ่ม getter สำหรับ UID

  // กำหนดว่าต้องการเจอสินทรัพย์หรือไม่
  void setFindPreference(bool wantToFind) {
    _wantToFind = wantToFind;
  }

  Future<void> performScan(BuildContext context) async {
    _status = RfidScanStatus.scanning;
    _errorMessage = '';
    notifyListeners();

    try {
      if (_wantToFind) {
        // กรณีกดปุ่ม Yes -> สุ่ม UID แล้วไปหน้า Found
        // สุ่ม UID จากฐานข้อมูลจริง
        final uid = await _getRandomUidUseCase.execute();

        _status = RfidScanStatus.found;
        notifyListeners();

        // ส่ง UID ไปด้วย
        Navigator.pushNamed(
          context,
          '/found',
          arguments: {'uid': uid ?? 'Unknown'},
        );
      } else {
        // กรณีกดปุ่ม No -> ไปหน้า Not Found เลย
        _status = RfidScanStatus.notFound;
        notifyListeners();

        Navigator.pushNamed(
          context,
          '/notFound',
          arguments: {'uid': 'Unknown'},
        );
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
