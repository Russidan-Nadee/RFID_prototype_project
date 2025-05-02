import 'package:flutter/material.dart';
import '../../../../domain/usecases/search_asset_usecase.dart';

enum RfidScanStatus { initial, scanning, found, notFound, error }

class RfidScanBloc extends ChangeNotifier {
  final SearchAssetUseCase _searchAssetUseCase;

  RfidScanStatus _status = RfidScanStatus.initial;
  String _errorMessage = '';
  String _lastScannedUid = '';

  RfidScanBloc(this._searchAssetUseCase);

  RfidScanStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get lastScannedUid => _lastScannedUid;

  Future<void> scanRfid(String uid, BuildContext context) async {
    if (uid.isEmpty) {
      _errorMessage = 'Please enter a UID';
      notifyListeners();
      return;
    }

    if (uid.length != 10) {
      _errorMessage = 'UID must be 10 characters long';
      notifyListeners();
      return;
    }

    _status = RfidScanStatus.scanning;
    _lastScannedUid = uid;
    _errorMessage = '';
    notifyListeners();

    try {
      await _searchAssetUseCase.execute(uid, context);
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
