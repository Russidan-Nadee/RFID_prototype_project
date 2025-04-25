import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class Rfidscan extends StatefulWidget {  // เปลี่ยนเป็น StatefulWidget
  const Rfidscan({super.key});

  @override
  State<Rfidscan> createState() => _RfidscanState(); // เชื่อมโยงกับ _RfidscanState
}

class _RfidscanState extends State<Rfidscan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  // ฟังก์ชันในการบันทึกข้อมูลลงไฟล์ CSV
  Future<void> _saveToCSV() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/assets_data.csv');

    bool fileExists = await file.exists();
    if (!fileExists) {
      List<List<dynamic>> data = [
        ['ID', 'UID', 'Category', 'Brand', 'Department'], // Header
      ];
      file.writeAsStringSync(ListToCsvConverter().convert(data));
    }

    String id = _idController.text;
    String uid = _uidController.text;
    String category = _categoryController.text;
    String brand = _brandController.text;
    String department = _departmentController.text;

    List<List<dynamic>> newData = [
      [id, uid, category, brand, department],
    ];

    file.writeAsStringSync(
      ListToCsvConverter().convert(newData),
      mode: FileMode.append,
    );

    // แสดงข้อความเมื่อบันทึกเสร็จ
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved to CSV!')));

    // รีเซ็ตค่าฟอร์มหลังจากบันทึก
    _idController.clear();
    _uidController.clear();
    _categoryController.clear();
    _brandController.clear();
    _departmentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RFID Scan Reader")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                label: Text("ID", style: TextStyle(fontSize: 20)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _uidController,
              decoration: const InputDecoration(
                label: Text("UID", style: TextStyle(fontSize: 20)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter UID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                label: Text("Category", style: TextStyle(fontSize: 20)),
              ),
            ),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                label: Text("Brand", style: TextStyle(fontSize: 20)),
              ),
            ),
            TextFormField(
              controller: _departmentController,
              decoration: const InputDecoration(
                label: Text("Department", style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _saveToCSV(); // บันทึกข้อมูลลงใน CSV เมื่อกดปุ่ม
                }
              },
              child: const Text('Save', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
