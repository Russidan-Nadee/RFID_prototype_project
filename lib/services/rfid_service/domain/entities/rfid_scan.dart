class RfidScan {
  final String uid;
  final DateTime scanTime;
  final bool isFound;

  RfidScan({required this.uid, required this.scanTime, required this.isFound});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'scanTime': scanTime.toIso8601String(),
      'isFound': isFound,
    };
  }

  factory RfidScan.fromJson(Map<String, dynamic> json) {
    return RfidScan(
      uid: json['uid'],
      scanTime: DateTime.parse(json['scanTime']),
      isFound: json['isFound'],
    );
  }
}
