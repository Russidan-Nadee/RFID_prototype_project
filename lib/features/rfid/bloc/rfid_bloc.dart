import 'package:flutter/foundation.dart';
import 'package:rfid_project/features/rfid/bloc/rfid_event.dart';
import 'package:rfid_project/features/rfid/bloc/rfid_state.dart';
import '../../../services/rfid_service/data/repositories/rfid_repository_impl.dart';

class RfidBloc extends ChangeNotifier {
  final RfidRepositoryImpl _repository;

  RfidState _state = RfidInitial();
  RfidState get state => _state;

  RfidBloc(this._repository);

  Future<void> add(RfidEvent event) async {
    if (event is ScanRfidEvent) {
      await _handleScanRfidEvent();
    } else if (event is MockScanRfidEvent) {
      await _handleMockScanRfidEvent(event.shouldFind);
    } else if (event is CheckDeviceStatusEvent) {
      await _handleCheckDeviceStatusEvent();
    } else if (event is SetMockModeEvent) {
      await _handleSetMockModeEvent(event.mode);
    } else if (event is StopScanEvent) {
      _handleStopScanEvent();
    }
  }

  Future<void> _handleScanRfidEvent() async {
    _state = RfidLoading();
    notifyListeners();

    try {
      final scan = await _repository.scanRfid();
      _state = RfidScanSuccess(scan);
    } catch (e) {
      _state = RfidScanFailure(e.toString());
    }

    notifyListeners();
  }

  Future<void> _handleMockScanRfidEvent(bool shouldFind) async {
    _state = RfidLoading();
    notifyListeners();

    try {
      final scan = await _repository.mockScanRfid(shouldFind);
      _state = RfidScanSuccess(scan);
    } catch (e) {
      _state = RfidScanFailure(e.toString());
    }

    notifyListeners();
  }

  Future<void> _handleCheckDeviceStatusEvent() async {
    _state = RfidLoading();
    notifyListeners();

    try {
      final isAvailable = await _repository.isDeviceAvailable();
      final isScanning = _repository.isScanning();

      _state = DeviceStatusState(isAvailable, isScanning);
    } catch (e) {
      _state = RfidScanFailure(e.toString());
    }

    notifyListeners();
  }

  Future<void> _handleSetMockModeEvent(String mode) async {
    _state = RfidLoading();
    notifyListeners();

    try {
      await _repository.setMockMode(mode);
      final currentMode = _repository.getCurrentMockMode();

      _state = MockModeState(currentMode);
    } catch (e) {
      _state = RfidScanFailure(e.toString());
    }

    notifyListeners();
  }

  void _handleStopScanEvent() {
    _repository.stopScan();
    _state = RfidInitial();
    notifyListeners();
  }

  // สร้างเหตุการณ์จากหน้าจอโดยตรงโดยไม่ต้องสร้าง instance ของ Event

  Future<void> scanRfid() async {
    await add(ScanRfidEvent());
  }

  Future<void> mockScan(bool shouldFind) async {
    await add(MockScanRfidEvent(shouldFind));
  }

  Future<void> checkDeviceStatus() async {
    await add(CheckDeviceStatusEvent());
  }

  Future<void> setMockMode(String mode) async {
    await add(SetMockModeEvent(mode));
  }

  void stopScan() {
    add(StopScanEvent());
  }
}
