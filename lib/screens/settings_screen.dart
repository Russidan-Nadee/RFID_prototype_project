import 'package:flutter/material.dart';
import 'package:rfid_project/sevice/database_sevice.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  // ฟังก์ชันสำหรับลบข้อมูลทั้งหมดจากฐานข้อมูล
  Future<void> _deleteAllAssets(BuildContext context) async {
    var dbHelper = DatabaseHelper();

    try {
      // เรียกฟังก์ชันในการลบข้อมูลทั้งหมดจากฐานข้อมูล
      await dbHelper.deleteAllAssets();

      // แจ้งผู้ใช้ว่าได้ทำการลบข้อมูลทั้งหมดแล้ว
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ข้อมูลทั้งหมดได้ถูกลบเรียบร้อยแล้ว')),
      );
    } catch (e) {
      // หากมีข้อผิดพลาดในการลบข้อมูล
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการลบข้อมูล: $e')),
      );
    }
  }

  // ฟังก์ชันสำหรับลบข้อมูลตาม UID
  Future<void> _deleteAssetByUid(BuildContext context, String uid) async {
    var dbHelper = DatabaseHelper();

    try {
      // เรียกฟังก์ชันในการลบข้อมูลที่มี UID จากฐานข้อมูล
      await dbHelper.deleteAssetByUid(uid);

      // แจ้งผู้ใช้ว่าได้ทำการลบข้อมูลที่ตรงกับ UID แล้ว
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ข้อมูลที่มี UID $uid ได้ถูกลบเรียบร้อยแล้ว')),
      );
    } catch (e) {
      // หากมีข้อผิดพลาดในการลบข้อมูล
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการลบข้อมูล: $e')),
      );
    }
  }

  // ฟังก์ชันสำหรับอัปเดตข้อมูล
  Future<void> _updateAsset(BuildContext context, String id, String category, String brand, String department, String uid) async {
    var dbHelper = DatabaseHelper();

    try {
      // เรียกฟังก์ชันในการอัปเดตสถานะในฐานข้อมูล
      bool success = await dbHelper.updateStatus(uid, 'Checked In'); // เปลี่ยนจาก updateAsset เป็น updateStatus

      if (success) {
        // แจ้งผู้ใช้ว่าได้ทำการอัปเดตข้อมูลแล้ว
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('สถานะของข้อมูลได้ถูกอัปเดตเป็น "Checked In" เรียบร้อยแล้ว')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่พบข้อมูลที่ตรงกับ UID $uid')),
        );
      }
    } catch (e) {
      // หากมีข้อผิดพลาดในการอัปเดตข้อมูล
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตข้อมูล: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ปุ่มลบข้อมูลทั้งหมด
            ElevatedButton(
              onPressed: () => _deleteAllAssets(context),
              child: const Text('Delete All Assets'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            const SizedBox(height: 20),

            // ฟอร์มกรอก UID สำหรับลบข้อมูลตาม UID
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter UID to Delete',
                border: OutlineInputBorder(),
              ),
              onChanged: (uid) {
                // การเก็บค่า UID ที่ผู้ใช้กรอก
              },
            ),
            const SizedBox(height: 20),

            // ปุ่มลบข้อมูลตาม UID
            ElevatedButton(
              onPressed: () {
                String uid = 'UID123';  // กรอก UID ที่ต้องการลบ
                _deleteAssetByUid(context, uid);
              },
              child: const Text('Delete Asset by UID'),
            ),
            const SizedBox(height: 20),

            // ฟอร์มกรอกข้อมูลเพื่ออัปเดตข้อมูล
            TextField(
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButton<String>(
              value: 'it',
              onChanged: (String? newValue) {
                // คำสั่งสำหรับเลือก department
              },
              items: <String>['it', 'hr', 'admin', 'finance']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ปุ่มอัปเดตข้อมูล
            ElevatedButton(
              onPressed: () {
                String id = 'ID123'; // ค่า ID ที่ต้องการอัปเดต
                String category = 'Category123'; // ค่า Category ที่ต้องการอัปเดต
                String brand = 'Brand123'; // ค่า Brand ที่ต้องการอัปเดต
                String department = 'it'; // ค่า Department ที่ต้องการอัปเดต
                String uid = 'UID123'; // ค่า UID ที่ต้องการอัปเดต
                _updateAsset(context, id, category, brand, department, uid);
              },
              child: const Text('Update Asset'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
