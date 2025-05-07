import 'dart:async';
import 'dart:math';

/// ระบุโหมดการจำลองสำหรับอุปกรณ์ RFID
enum MockMode {
  normal, // โหมดปกติ (สุ่ม)
  found, // จำลองว่าเจอสินทรัพย์ในระบบเสมอ
  notFound, // จำลองว่าไม่เจอสินทรัพย์ในระบบเสมอ
  scanFailed, // จำลองว่าสแกนล้มเหลวเสมอ
}

/// อินเทอร์เฟซสำหรับอุปกรณ์ RFID
abstract class RfidDeviceInterface {
  /// ตรวจสอบว่าอุปกรณ์พร้อมใช้งานหรือไม่
  bool isAvailable();

  /// สแกน RFID tag และส่งคืน UID
  /// ถ้าสแกนไม่สำเร็จจะส่งคืน null
  Future<String?> scanRfid();

  /// ตรวจสอบว่ากำลังสแกนอยู่หรือไม่
  bool isScanning();

  /// หยุดการสแกน
  void stopScan();

  /// ตั้งค่าโหมดการจำลอง
  void setMockMode(MockMode mode);

  /// ดึงโหมดการจำลองปัจจุบัน
  MockMode getCurrentMode();
}

/// การจำลองอุปกรณ์ RFID สำหรับการทดสอบ
class MockRfidDeviceInterface implements RfidDeviceInterface {
  // UID ที่มีในระบบ (จำลอง)
  final List<String> _registeredUids = [
    'ABC1234567',
    'XYZ9876543',
    'DEF5678901',
  ];

  // UID ที่ไม่มีในระบบ (จำลอง)
  final List<String> _unregisteredUids = [
    'UNR1234567',
    'NEW9876543',
    'MIS5678901',
  ];

  bool _scanning = false;
  MockMode _currentMode = MockMode.normal;

  @override
  void setMockMode(MockMode mode) {
    _currentMode = mode;
  }

  @override
  MockMode getCurrentMode() {
    return _currentMode;
  }

  @override
  bool isAvailable() {
    // จำลองว่าอุปกรณ์พร้อมใช้งานเสมอ
    return true;
  }

  @override
  Future<String?> scanRfid() async {
    _scanning = true;

    // จำลองเวลาที่ใช้ในการสแกน (1-2 วินาที)
    await Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(1000)));

    // ถ้ามีการยกเลิกการสแกนระหว่างรอ
    if (!_scanning) {
      return null;
    }

    _scanning = false;

    // ตรวจสอบโหมดการจำลองและส่งค่ากลับตามโหมด
    switch (_currentMode) {
      case MockMode.found:
        // ส่งค่า UID ที่มีในระบบกลับไป
        return _registeredUids[Random().nextInt(_registeredUids.length)];

      case MockMode.notFound:
        // ส่งค่า UID ที่ไม่มีในระบบกลับไป
        return _unregisteredUids[Random().nextInt(_unregisteredUids.length)];

      case MockMode.scanFailed:
        // จำลองการสแกนล้มเหลว
        return null;

      case MockMode.normal:
        // โหมดปกติ - สุ่มว่าจะสแกนสำเร็จหรือไม่ และสุ่มว่าจะเจอหรือไม่เจอ
        if (Random().nextDouble() < 0.9) {
          // 90% โอกาสที่จะสแกนสำเร็จ
          if (Random().nextBool()) {
            // 50% โอกาสที่จะเจอในระบบ
            return _registeredUids[Random().nextInt(_registeredUids.length)];
          } else {
            // 50% โอกาสที่จะไม่เจอในระบบ
            return _unregisteredUids[Random().nextInt(
              _unregisteredUids.length,
            )];
          }
        } else {
          // 10% โอกาสที่จะสแกนไม่สำเร็จ
          return null;
        }
    }
  }

  @override
  bool isScanning() {
    return _scanning;
  }

  @override
  void stopScan() {
    _scanning = false;
  }
}
