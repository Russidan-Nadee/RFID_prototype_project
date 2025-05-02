import 'package:flutter/material.dart';
import '../../presentation/features/assets/screens/search_assets_screen.dart';
import '../../presentation/features/assets/screens/view_assets_screen.dart';
import '../../presentation/features/dashboard/screens/home_screen.dart';
import '../../presentation/features/export/screens/export_screen.dart';
import '../../presentation/features/rfid/screens/found_screen.dart';
import '../../presentation/features/rfid/screens/not_found_screen.dart';
import '../../presentation/features/rfid/screens/scan_rfid_screen.dart';
import '../../presentation/features/settings/screens/settings_screen.dart';
import '../constants/route_constants.dart';

class AppRoutes {
  // Route names
  static const String home = RouteConstants.home;
  static const String searchAssets = RouteConstants.searchAssets;
  static const String scanRfid = RouteConstants.scanRfid;
  static const String viewAssets = RouteConstants.viewAssets;
  static const String export = RouteConstants.export;
  static const String found = RouteConstants.found;
  static const String notFound = RouteConstants.notFound;
  static const String settings = RouteConstants.settings;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case searchAssets:
        return MaterialPageRoute(builder: (_) => SearchAssetsScreen());
      case scanRfid:
        return MaterialPageRoute(builder: (_) => ScanRfidScreen());
      case viewAssets:
        return MaterialPageRoute(builder: (_) => ViewAssetsScreen());
      case export:
        return MaterialPageRoute(builder: (_) => ExportScreen());
      case found:
        return MaterialPageRoute(builder: (_) => FoundScreen());
      case notFound:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
