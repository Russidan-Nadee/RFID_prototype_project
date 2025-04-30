import 'package:flutter/material.dart';
import 'package:rfid_project/foundornot/found_screen.dart';
import 'package:rfid_project/foundornot/not_found_screen.dart';
import 'package:rfid_project/sevice/database_sevice.dart';

class ScanRfidScreen extends StatefulWidget {
  const ScanRfidScreen({Key? key}) : super(key: key);

  @override
  State<ScanRfidScreen> createState() => _ScanRfidScreenState();
}

class _ScanRfidScreenState extends State<ScanRfidScreen> {
  final TextEditingController _uidController = TextEditingController();
  String? errorMessage;

  // ฟังก์ชันค้นหาข้อมูลในฐานข้อมูล
  Future<void> _searchAsset() async {
    String uid = _uidController.text;

    // 1. ตรวจสอบว่า UID มีความยาว 10 ตัว
    if (uid.length == 10) {
      var dbHelper = DatabaseHelper();
      var asset = await dbHelper.getAssetByUid(uid); // ค้นหาข้อมูลจาก UID

      // 2. ตรวจสอบการจับคู่ UID กับข้อมูลในฐานข้อมูล
      if (asset != null && asset['uid'] == uid) {
        // ถ้าพบข้อมูลตรงกับ UID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoundScreen(uid: uid), // ส่งค่า uid ไปที่ FoundScreen
          ),
        );
      } else {
        // ถ้าข้อมูลไม่ตรงกัน
        setState(() {
          errorMessage = 'ไม่พบข้อมูลสำหรับ UID: $uid.'; // ข้อความเมื่อไม่พบข้อมูล
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotFoundScreen(uid: uid), // ไปที่หน้าข้อมูลไม่พบ
          ),
        );
      }
    } else {
      // หาก UID ไม่ครบ 10 ตัว
      setState(() {
        errorMessage = 'Error: UID length must be 10 characters.'; // หาก UID ไม่ใช่ 10 ตัว
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ช่องกรอก UID
              TextField(
                controller: _uidController,
                decoration: InputDecoration(
                  labelText: 'กรอก UID หรือ Asset ID',
                  prefixIcon: const Icon(Icons.qr_code),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // แสดงข้อความหากไม่มีการกรอก UID หรือ UID ไม่ถูกต้อง
              if (errorMessage != null)
                Text(errorMessage!, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _searchAsset, // เรียกใช้ฟังก์ชันค้นหา
                child: const Text('Scan RFID'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
