class AppConstants {
  // ค่าคงที่พื้นฐานของแอพ
  static const int splashDuration = 2;
  static const int maxAssetNameLength = 100;

  // ค่าสถานะมาตรฐาน
  static const String statusAvailable = 'Available';
  static const String statusCheckedIn = 'Checked In';

  // ค่าเริ่มต้นสำหรับหมวดหมู่สินทรัพย์
  static const List<String> defaultAssetCategories = [
    'Laptop',
    'Monitor',
    'Mouse',
    'Phone',
    'Other',
  ];

  // ค่าเริ่มต้นสำหรับแผนก
  static const List<String> defaultDepartments = [
    'IT',
    'HR',
    'Finance',
    'Admin',
  ];

  // ข้อจำกัดของชื่อหมวดหมู่และแผนก
  static const int maxCategoryNameLength = 50;
  static const int maxDepartmentNameLength = 50;
}
