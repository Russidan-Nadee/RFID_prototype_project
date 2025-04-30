import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rfid_project/sevice/database_sevice.dart'; // นำเข้า DatabaseHelper

class NotFoundScreen extends StatefulWidget {
  final String uid; // รับค่า UID จากหน้า ScanRfidScreen

  // Constructor รับพารามิเตอร์ UID
  NotFoundScreen({required this.uid});

  @override
  _NotFoundScreenState createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  
  String? _selectedDepartment = 'it'; // Department ที่เลือก
  final List<String> _departments = ['it', 'hr', 'admin', 'finance']; // ตัวเลือกของ department

  // ฟังก์ชันสำหรับส่งข้อมูลไปที่ฐานข้อมูล
  Future<void> _submitForm() async {
    // รับค่าจากฟอร์มแล้วแปลงเป็นตัวพิมพ์ใหญ่
    String id = _idController.text.toUpperCase(); // แปลง ID เป็นตัวพิมพ์ใหญ่
    String category = _categoryController.text;
    String brand = _brandController.text;
    String department = _selectedDepartment!; // Department
    String uid = widget.uid.toUpperCase(); // แปลง UID ที่รับมาเป็นตัวพิมพ์ใหญ่

    // ดึงวันที่ปัจจุบัน
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    try {
      // ตรวจสอบว่าผู้ใช้กรอกข้อมูลครบถ้วน
      if (id.isEmpty || category.isEmpty || brand.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
        );
        return;
      }

      // บันทึกข้อมูลลงในฐานข้อมูล
      var dbHelper = DatabaseHelper();
      await dbHelper.insertNewAsset(id, category, brand, department, uid, currentDate);

      // แสดงข้อความยืนยันการส่งข้อมูล
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ข้อมูลได้ถูกส่งไปเรียบร้อยแล้ว')),
      );

      // เพิ่มการออกจากหน้าจอเมื่อส่งข้อมูลสำเร็จ
      Navigator.pop(context);
    } catch (e) {
      // จัดการข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Not Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // กลับไปที่หน้าก่อนหน้า
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ข้อความที่แสดงเมื่อไม่พบข้อมูล
            Center(
              child: Text(
                'Create new assets for UID: ${widget.uid}', // แสดง UID ที่ไม่พบ
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // ฟอร์มกรอกข้อมูล UID (ไม่สามารถแก้ไขได้)
            TextField(
              controller: TextEditingController(text: widget.uid), // แสดง UID ในฟอร์ม
              decoration: InputDecoration(
                labelText: 'UID',
                border: OutlineInputBorder(),
              ),
              enabled: false, // ทำให้ไม่สามารถแก้ไขค่า UID
            ),
            const SizedBox(height: 12),

            // ฟอร์มกรอกข้อมูล ID
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // ฟอร์มกรอกข้อมูล Category
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // ฟอร์มกรอกข้อมูล Brand
            TextField(
              controller: _brandController,
              decoration: InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Dropdown สำหรับเลือก department
            DropdownButton<String>(
              value: _selectedDepartment,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue;
                });
              },
              items: _departments.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Department'),
            ),
            const SizedBox(height: 20),

            // ปุ่มยืนยันการกรอกข้อมูล
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
