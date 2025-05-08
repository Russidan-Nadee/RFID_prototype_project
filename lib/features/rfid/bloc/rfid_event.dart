abstract class RfidEvent {}

class ScanRfidEvent extends RfidEvent {}

class MockScanRfidEvent extends RfidEvent {
  final bool shouldFind;

  MockScanRfidEvent(this.shouldFind);
}

class CheckDeviceStatusEvent extends RfidEvent {}

class SetMockModeEvent extends RfidEvent {
  final String mode;

  SetMockModeEvent(this.mode);
}

class StopScanEvent extends RfidEvent {}
