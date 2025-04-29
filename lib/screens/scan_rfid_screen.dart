import 'package:flutter/material.dart';
import 'package:rfid_project/sevice/database_sevice.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScanRfidScreen extends StatefulWidget {
  const ScanRfidScreen({Key? key}) : super(key: key);

  @override
  State<ScanRfidScreen> createState() => _ScanRfidScreenState();
}

class _ScanRfidScreenState extends State<ScanRfidScreen> {
  final TextEditingController _uidController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  List<String> departments = ['HR', 'IT', 'Marketing', 'Sales']; // Dropdown ของ Department
  String selectedDepartment = 'HR'; // ค่าของ department
  Map<String, dynamic>? assetData; // สำหรับเก็บข้อมูลที่ดึงจากฐานข้อมูล

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulated RFID Scan'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ช่องกรอก UID
            TextField(
              controller: _uidController,
              decoration: InputDecoration(
                labelText: 'Enter UID or Asset ID',
                prefixIcon: const Icon(Icons.qr_code),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scanAsset, // กดเพื่อสแกนและตรวจสอบ UID
              child: const Text('Scan Asset'),
            ),
            const SizedBox(height: 20),
            // ถ้าไม่พบ UID ให้แสดง Dropdown และปุ่ม Create New Asset
            if (assetData == null) ...[
              const Text('Department:'),
              DropdownButton<String>(
                value: selectedDepartment,
                items: departments.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDepartment = newValue!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _createNewAsset, // เมื่อกดปุ่มนี้จะสร้างสินทรัพย์ใหม่
                child: const Text('Create New Asset'),
              ),
            ],
            // แสดงรายละเอียดเมื่อพบข้อมูลในฐานข้อมูล
            if (assetData != null) ...[
              const Text('Asset Details:'),
              Text('ID: ${assetData!['id']}'),
              Text('Category: ${assetData!['category']}'),
              Text('Brand: ${assetData!['brand']}'),
              Text('Status: ${assetData!['status']}'),
              Text('Date: ${assetData!['date']}'),
              ElevatedButton(
                onPressed: _checkInAsset, // เมื่อกดจะทำการ Check In
                child: const Text('Check In'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสแกนและค้นหาในฐานข้อมูล
  void _scanAsset() async {
    String uid = _uidController.text.trim();
    if (uid.isNotEmpty) {
      var data = await dbHelper.getAssetByUid(uid);
      if (data != null) {
        setState(() {
          assetData = data; // แสดงข้อมูลเมื่อพบ UID
        });
      } else {
        setState(() {
          assetData = null; // หากไม่พบ ให้แสดง form สำหรับสร้าง asset ใหม่
        });
      }
    }
  }

  // ฟังก์ชันสำหรับการสร้าง Asset ใหม่
  void _createNewAsset() {
    DateTime now = DateTime.now();
    String currentDate = now.toIso8601String();  // เวลาปัจจุบัน

    // สร้างข้อมูลใหม่
    dbHelper.insertNewAsset(
      {
        'id': 'NewID-${DateTime.now().millisecondsSinceEpoch}', // ตัวอย่างการสร้าง ID ใหม่
        'category': 'Uncategorized',
        'brand': 'Unknown',
        'department': selectedDepartment,  // กรอกจาก Dropdown
        'status': 'Available',  // สถานะเริ่มต้นเป็น Available
        'date': currentDate,  // วันที่และเวลาปัจจุบัน
      },
    );

    showToast("New asset created!");
  }

  // ฟังก์ชันสำหรับการอัปเดตสถานะเป็น Checked In
  void _checkInAsset() async {
    if (assetData != null) {
      DateTime now = DateTime.now();
      String currentDate = now.toIso8601String(); // ใช้เวลาปัจจุบันจากเครื่อง

      // อัปเดตสถานะจาก Available -> Checked In
      await dbHelper.updateAssetStatus(
        assetData!['id'], 
        'Checked In', 
        currentDate,  // กำหนดวันที่เป็นเวลาปัจจุบัน
      );

      showToast("Asset checked in!");
    }
  }

  // Toast function for showing messages
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }
}
