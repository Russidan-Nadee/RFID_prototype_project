import 'package:flutter/material.dart';
import 'screens/homepage.dart'; // นำเข้าไฟล์ที่สร้างหน้า Homepage (Dashboard)

void main() {
  runApp(const MyApp()); // เริ่มต้นแอป
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard', // ตั้งชื่อให้กับแอป
      theme: ThemeData(
        primarySwatch: Colors.blue, // เพิ่มสีหลักให้กับแอป
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black), // ใช้ bodyLarge แทน bodyText1
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey), // ใช้ bodyMedium แทน bodyText2
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // ใช้ headlineMedium แทน headline6
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600), // ปรับแต่งสไตล์ของหัวเรื่องใน AppBar
          ),
        ),
        body: const Homepage(), // ตั้งหน้า Homepage เป็นเนื้อหาหลัก
      ),
    );
  }
}
