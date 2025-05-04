// ไฟล์นี้จัดการการลงทะเบียนส่วนต่างๆ ของแอปให้สามารถใช้งานร่วมกันได้

// นำเข้าไลบรารี get_it ซึ่งช่วยในการจัดการการพึ่งพากันของชิ้นส่วนต่างๆ ในแอป
import 'package:get_it/get_it.dart';
// นำเข้าโมดูลย่อยที่จะลงทะเบียน
import 'package:rfid_project/core/di/modules/database_module.dart'; // โมดูลฐานข้อมูล
import 'package:rfid_project/core/di/modules/repository_module.dart'; // โมดูลคลังข้อมูล
import 'package:rfid_project/core/di/modules/service_module.dart'; // โมดูลบริการ

// สร้างตัวแปร getIt เพื่อใช้เป็นจุดศูนย์กลางในการเข้าถึงส่วนต่างๆ ของแอป
final GetIt getIt = GetIt.instance;

// คลาสสำหรับจัดการการลงทะเบียนส่วนประกอบต่างๆ ของแอป
class DependencyInjection {
  // ฟังก์ชันเริ่มต้นที่ลงทะเบียนทุกโมดูล
  static Future<void> init() async {
    // ลงทะเบียนโมดูลฐานข้อมูล (เช่น SQLite) ก่อน
    // เพราะส่วนอื่นๆ จะต้องใช้การเชื่อมต่อฐานข้อมูล
    await DatabaseModule().register();

    // ลงทะเบียนโมดูลคลังข้อมูล ซึ่งใช้ในการติดต่อกับฐานข้อมูล
    // โมดูลนี้จะใช้ DatabaseModule ที่ลงทะเบียนก่อนหน้า
    await RepositoryModule().register();

    // ลงทะเบียนโมดูลบริการ ซึ่งมีฟังก์ชันการทำงานระดับสูง
    // โมดูลนี้จะใช้ RepositoryModule ที่ลงทะเบียนก่อนหน้า
    await ServiceModule().register();
  }
}
