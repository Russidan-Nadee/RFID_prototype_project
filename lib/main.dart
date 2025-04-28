import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFID Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey),
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      home: const home_page(),
      debugShowCheckedModeBanner: false, // ปิดแถบ debug สีแดง
    );
  }
}
