import 'package:flutter/material.dart';
import 'package:rfid_project/screens/export_screen.dart';
import 'package:rfid_project/screens/home_screen.dart';
import 'package:rfid_project/screens/scan_rfid_screen.dart';
import 'package:rfid_project/screens/search_assets_screen.dart';
import 'package:rfid_project/screens/settings_screen.dart';
import 'package:rfid_project/screens/view_assets_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFID App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // เริ่มต้นที่ Home (Index 2)

  final List<Widget> _screens = [
    const ViewAssetsScreen(),
    const SearchAssetsScreen(),
    const HomeScreen(),
    const ScanRfidScreen(),
    const ExportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(),
          style: const TextStyle(
            color: Color(0xFF007BFF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_currentIndex == 2) // เฉพาะหน้า Home เท่านั้น
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFF007BFF)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF007BFF),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Roboto'),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_export),
            label: 'Export',
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'View Status';
      case 1:
        return 'Search Assets';
      case 2:
        return 'Home';
      case 3:
        return 'Scan RFID';
      case 4:
        return 'Export';
      default:
        return '';
    }
  }
}
