// ไฟล์นี้จัดการเส้นทางทั้งหมดในแอป - ทำหน้าที่เชื่อมโยงเส้นทางกับหน้าจอที่ต้องแสดง

// นำเข้าไลบรารี Flutter สำหรับสร้าง UI
import 'package:flutter/material.dart';
// นำเข้าหน้าจอค้นหาสินทรัพย์
import '../../presentation/features/assets/screens/search_assets_screen.dart';
// นำเข้าหน้าจอดูรายละเอียดสินทรัพย์
import '../../presentation/features/assets/screens/view_assets_screen.dart';
// นำเข้าหน้าจอหลัก
import '../../presentation/features/dashboard/screens/home_screen.dart';
// นำเข้าหน้าจอส่งออกข้อมูล
import '../../presentation/features/export/screens/export_screen.dart';
// นำเข้าหน้าจอแสดงผลเมื่อพบสินทรัพย์
import '../../presentation/features/rfid/screens/found_screen.dart';
// นำเข้าหน้าจอแสดงผลเมื่อไม่พบสินทรัพย์
import '../../presentation/features/rfid/screens/not_found_screen.dart';
// นำเข้าหน้าจอสแกน RFID
import '../../presentation/features/rfid/screens/scan_rfid_screen.dart';
// นำเข้าหน้าจอตั้งค่า
import '../../presentation/features/settings/screens/settings_screen.dart';
// นำเข้าค่าคงที่ของเส้นทาง
import '../constants/route_constants.dart';

// คลาสจัดการเส้นทางทั้งหมดในแอป
class AppRoutes {
  // ประกาศชื่อเส้นทางต่างๆ โดยใช้ค่าจาก RouteConstants
  static const String home = RouteConstants.home; // เส้นทางไปหน้าหลัก
  static const String searchAssets =
      RouteConstants.searchAssets; // เส้นทางไปหน้าค้นหา
  static const String scanRfid = RouteConstants.scanRfid; // เส้นทางไปหน้าสแกน
  static const String viewAssets =
      RouteConstants.viewAssets; // เส้นทางไปหน้าดูสินทรัพย์
  static const String export = RouteConstants.export; // เส้นทางไปหน้าส่งออก
  static const String found = RouteConstants.found; // เส้นทางไปหน้าพบสินทรัพย์
  static const String notFound =
      RouteConstants.notFound; // เส้นทางไปหน้าไม่พบสินทรัพย์
  static const String settings =
      RouteConstants.settings; // เส้นทางไปหน้าตั้งค่า

  // ฟังก์ชันสร้างเส้นทางตามชื่อที่ได้รับ
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    // รับ arguments ที่ส่งมาพร้อมกับการนำทาง
    final args = routeSettings.arguments;

    // ตรวจสอบชื่อเส้นทางและสร้างหน้าจอที่เหมาะสม
    switch (routeSettings.name) {
      case home:
        // ถ้าเป็นหน้าหลัก สร้างหน้า HomeScreen
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case searchAssets:
        // ถ้าเป็นหน้าค้นหา สร้างหน้า SearchAssetsScreen
        return MaterialPageRoute(builder: (_) => SearchAssetsScreen());
      case scanRfid:
        // ถ้าเป็นหน้าสแกน สร้างหน้า ScanRfidScreen
        return MaterialPageRoute(builder: (_) => ScanRfidScreen());
      case viewAssets:
        // ถ้าเป็นหน้าดูสินทรัพย์ สร้างหน้า ViewAssetsScreen
        return MaterialPageRoute(builder: (_) => ViewAssetsScreen());
      case export:
        // ถ้าเป็นหน้าส่งออก สร้างหน้า ExportScreen
        return MaterialPageRoute(builder: (_) => ExportScreen());
      case found:
        // ถ้าเป็นหน้าพบสินทรัพย์ สร้างหน้า FoundScreen พร้อมส่งข้อมูล asset และ uid
        // ตรวจสอบว่ามีการส่ง args มาหรือไม่
        if (args is Map<String, dynamic>) {
          // ส่งข้อมูล asset และ uid ไปยัง FoundScreen
          return MaterialPageRoute(
            builder: (_) => FoundScreen(asset: args['asset'], uid: args['uid']),
          );
        }
        // กรณีไม่มี args หรือ args ไม่ถูกต้อง ให้กลับไปหน้าสแกน
        return MaterialPageRoute(builder: (_) => ScanRfidScreen());
      case notFound:
        // ถ้าเป็นหน้าไม่พบสินทรัพย์ สร้างหน้า NotFoundScreen พร้อมส่ง uid
        if (args is Map<String, dynamic>) {
          // ส่งข้อมูล uid ไปยัง NotFoundScreen
          return MaterialPageRoute(
            builder: (_) => NotFoundScreen(uid: args['uid']),
          );
        }
        // กรณีไม่มี args หรือ args ไม่ถูกต้อง ให้กลับไปหน้าสแกน
        return MaterialPageRoute(builder: (_) => ScanRfidScreen());
      case settings:
        // ถ้าเป็นหน้าตั้งค่า สร้างหน้า SettingsScreen
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        // ถ้าไม่ตรงกับเส้นทางใดเลย ให้ไปที่หน้าหลัก
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
