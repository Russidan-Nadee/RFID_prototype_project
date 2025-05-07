class Asset {
  final String id;
  final String category;
  final String status;
  final String brand;
  final String uid;
  final String department;
  final String date;

  Asset({
    required this.id,
    required this.category,
    required this.status,
    required this.brand,
    required this.uid,
    required this.department,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'status': status,
      'brand': brand,
      'uid': uid,
      'department': department,
      'date': date,
    };
  }

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      category: json['category'],
      status: json['status'],
      brand: json['brand'],
      uid: json['uid'],
      department: json['department'],
      date: json['date'],
    );
  }

  Asset copyWith({
    String? id,
    String? category,
    String? status,
    String? brand,
    String? uid,
    String? department,
    String? date,
  }) {
    return Asset(
      id: id ?? this.id,
      category: category ?? this.category,
      status: status ?? this.status,
      brand: brand ?? this.brand,
      uid: uid ?? this.uid,
      department: department ?? this.department,
      date: date ?? this.date,
    );
  }
}
