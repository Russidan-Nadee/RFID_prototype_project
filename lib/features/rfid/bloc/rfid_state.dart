import '../../../services/rfid_service/domain/entities/rfid_scan.dart';

abstract class RfidState {}

class RfidInitial extends RfidState {}

class RfidLoading extends RfidState {}

class RfidScanSuccess extends RfidState {
  final RfidScan scan;

  RfidScanSuccess(this.scan);
}

class RfidScanFailure extends RfidState {
  final String message;

  RfidScanFailure(this.message);
}

class DeviceStatusState extends RfidState {
  final bool isAvailable;
  final bool isScanning;

  DeviceStatusState(this.isAvailable, this.isScanning);
}

class MockModeState extends RfidState {
  final String currentMode;

  MockModeState(this.currentMode);
}
