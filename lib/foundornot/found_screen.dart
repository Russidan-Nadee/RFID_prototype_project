import 'package:flutter/material.dart';
import 'package:rfid_project/sevice/database_sevice.dart';

class FoundScreen extends StatefulWidget {
  final String uid; // รับค่า UID จากหน้า ScanRfidScreen

  // Constructor รับพารามิเตอร์ UID
  const FoundScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _FoundScreenState createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  late Map<String, dynamic> _assetData = {}; // เก็บข้อมูลที่ดึงจากฐานข้อมูล
  bool _isLoading = true; // สถานะการโหลดข้อมูล
  bool _isProcessing = false; // สถานะการประมวลผลการ check in

  @override
  void initState() {
    super.initState();
    _getAssetData(); // เรียกฟังก์ชันเมื่อหน้าถูกโหลด
  }

  // ฟังก์ชันดึงข้อมูลจากฐานข้อมูลโดยใช้ UID
  Future<void> _getAssetData() async {
    setState(() {
      _isLoading = true;
    });

    var dbHelper = DatabaseHelper();
    var asset = await dbHelper.getAssetByUid(widget.uid);

    // ตรวจสอบว่าได้ข้อมูลหรือไม่
    setState(() {
      _assetData = asset ?? {};
      _isLoading = false;
    });
  }

  // ฟังก์ชันอัพเดตสถานะเป็น Checked In
  Future<void> _checkIn() async {
    if (_isProcessing) return; // ป้องกันการกดปุ่มซ้ำ

    setState(() {
      _isProcessing = true;
    });

    try {
      var dbHelper = DatabaseHelper();

      // อัพเดตสถานะในฐานข้อมูล
      bool updated = await dbHelper.updateStatus(widget.uid, 'Checked In');

      if (updated) {
        // แสดงข้อความแจ้งเตือนว่าอัปเดทสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Checked In successfully!'),
            duration: Duration(seconds: 1),
          ),
        );

        // รอให้ snackbar แสดงสักครู่ก่อนที่จะกลับไปยังหน้าก่อนหน้า
        await Future.delayed(const Duration(milliseconds: 500));
        
        // กลับไปยังหน้าก่อนหน้า
        if (mounted) {
          Navigator.of(context).pop(true); // ส่งค่า true กลับไปเพื่อบอกว่า check in สำเร็จ
        }
      } else {
        // แสดงข้อความแจ้งเตือนว่าอัปเดทไม่สำเร็จ
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update status.')),
          );
          setState(() {
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      // จัดการกรณีเกิดข้อผิดพลาด
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(false); // กลับไปหน้าก่อนหน้า ส่งค่า false หมายถึงไม่ได้ check in
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _assetData.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UID: ${_assetData['uid']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'ID: ${_assetData['id']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Category: ${_assetData['category']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Brand: ${_assetData['brand']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Department: ${_assetData['department']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Status: ${_assetData['status']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Date: ${_assetData['date']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        // เพิ่มปุ่ม Check In
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isProcessing ? null : _checkIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: _isProcessing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Check In',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        'No data found for this UID.',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
            ),
    );
  }
}