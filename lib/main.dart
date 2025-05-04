// ไฟล์นี้เป็นจุดเริ่มต้นของแอพ

import 'package:flutter/material.dart'; // เรียกใช้สิ่งที่ Flutter มีให้ใช้ในการสร้างแอพ
import 'core/navigation/app_routes.dart'; // เรียกใช้ตัวที่บอกว่าหน้าไหนอยู่ตรงไหนในแอพ
import 'core/theme/app_theme.dart'; // เรียกใช้ตัวที่เก็บสีและแบบต่างๆ ของแอพ

void main() {
  runApp(MyApp()); // บอกให้เริ่มทำงานแอพจากตรงนี้
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFID Asset Management', // ตั้งชื่อแอพ
      theme: AppTheme.lightTheme, // เลือกใช้แบบสว่าง
      initialRoute: AppRoutes.home, // ตั้งให้เริ่มต้นที่หน้าโฮม
      onGenerateRoute:
          AppRoutes
              .generateRoute, // บอกให้ Flutter รู้วิธีสร้างหน้าต่างๆ เมื่อมีการนำทาง
      debugShowCheckedModeBanner: false, // ปิดไม่ให้แสดงป้าย DEBUG ที่มุมบนขวา
    );
  }
}
