import '../../domain/entities/asset.dart';

class AssetModel extends Asset {
  AssetModel({
    required String id,
    required String category,
    required String status,
    required String brand,
    required String uid,
    required String department,
    required String date,
  }) : super(
         id: id,
         category: category,
         status: status,
         brand: brand,
         uid: uid,
         department: department,
         date: date,
       );

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      status: map['status'] ?? '',
      brand: map['brand'] ?? '',
      uid: map['uid'] ?? '',
      department: map['department'] ?? '',
      date: map['date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
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

  factory AssetModel.fromEntity(Asset asset) {
    return AssetModel(
      id: asset.id,
      category: asset.category,
      status: asset.status,
      brand: asset.brand,
      uid: asset.uid,
      department: asset.department,
      date: asset.date,
    );
  }
}
