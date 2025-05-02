class AppConstants {
  // App-wide constants
  static const int splashDuration = 2; // seconds
  static const int maxAssetNameLength = 100;

  // Status values
  static const String statusAvailable = 'Available';
  static const String statusCheckedIn = 'Checked In';
  static const String statusCheckedOut = 'Checked Out';
  static const String statusMaintenance = 'Maintenance';

  // Category values
  static const List<String> assetCategories = [
    'Laptop',
    'Monitor',
    'Mouse',
    'Phone',
    'Other',
  ];

  // Department values
  static const List<String> departments = ['IT', 'HR', 'Finance', 'Admin'];
}
