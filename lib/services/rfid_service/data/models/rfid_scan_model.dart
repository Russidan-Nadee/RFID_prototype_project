import '../../domain/entities/rfid_scan.dart';

class RfidScanModel extends RfidScan {
  RfidScanModel({
    required String uid,
    required DateTime scanTime,
    required bool isFound,
  }) : super(uid: uid, scanTime: scanTime, isFound: isFound);

  factory RfidScanModel.fromMap(Map<String, dynamic> map) {
    return RfidScanModel(
      uid: map['uid'],
      scanTime: DateTime.parse(map['scanTime']),
      isFound: map['isFound'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'scanTime': scanTime.toIso8601String(),
      'isFound': isFound,
    };
  }

  factory RfidScanModel.fromEntity(RfidScan entity) {
    return RfidScanModel(
      uid: entity.uid,
      scanTime: entity.scanTime,
      isFound: entity.isFound,
    );
  }
}
