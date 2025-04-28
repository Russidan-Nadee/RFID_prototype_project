import 'package:flutter/material.dart';
import '../database.dart'; // import database helper

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();

  int totalAssets = 0;
  int checkedInAssets = 0;
  int availableAssets = 0;
  int rfidScansToday = 0; // ตอนนี้ยังเป็น 0 เพราะยังไม่มี table RFID Scans

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final assets = await dbHelper.getAssets();

    int total = assets.length;
    int checkedIn = assets.where((a) => a['status'] == 'Checked In').length;
    int available = assets.where((a) => a['status'] == 'Available').length;

    // ถ้ามีระบบ RFID Scan ค่อยดึงข้อมูลมา ตอนนี้ set เป็น 0 ไว้ก่อน
    int rfidToday = 0;

    setState(() {
      totalAssets = total;
      checkedInAssets = checkedIn;
      availableAssets = available;
      rfidScansToday = rfidToday;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Welcome to Dashboard!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2),
                title: const Text('Assets Total'),
                trailing: Text(
                  '$totalAssets Units',
                  style: const TextStyle(
                    fontSize: 18, // เพิ่มขนาดฟอนต์
                    fontWeight: FontWeight.bold, // เน้นหนาให้ชัดขึ้น
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Checked In'),
                trailing: Text(
                  '$checkedInAssets Units',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.assignment_turned_in),
                title: const Text('Available'),
                trailing: Text(
                  '$availableAssets Units',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('RFID Scan Today'),
                trailing: Text(
                  '$rfidScansToday Times',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
