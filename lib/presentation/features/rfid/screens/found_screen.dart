import 'package:flutter/material.dart';
import '../../../common_widgets/buttons/primary_button.dart';
import '../../../common_widgets/layouts/screen_container.dart';
import '../../../../domain/entities/asset.dart';

class FoundScreen extends StatelessWidget {
  final Asset asset;
  final String uid;

  const FoundScreen({Key? key, required this.asset, required this.uid})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      appBar: AppBar(title: const Text('Asset Found')),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงข้อความว่าพบสินทรัพย์
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 64,
                ),
              ),
            ),

            const Center(
              child: Text(
                'Asset Found in System',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // แสดงข้อมูล UID
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RFID Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'UID: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(uid),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // แสดงข้อมูลสินทรัพย์
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Asset Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Asset ID', asset.id),
                    _buildDetailRow('Brand', asset.brand),
                    _buildDetailRow('Category', asset.category),
                    _buildDetailRow('Department', asset.department),
                    _buildDetailRow('Status', asset.status),
                    _buildDetailRow('Last Updated', asset.date),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ปุ่มอัปเดตสถานะ
            Center(
              child: PrimaryButton(
                text: 'Update Status',
                icon: Icons.update,
                onPressed: () {
                  _showUpdateStatusDialog(context);
                },
              ),
            ),

            const SizedBox(height: 16),

            // ปุ่มกลับไปหน้าสแกน
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).popUntil((route) => route.settings.name == '/scanRfid');
                },
                child: const Text('Back to Scanner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // สร้างแถวข้อมูลรายละเอียด
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // แสดง dialog อัปเดตสถานะ
  void _showUpdateStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Asset Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusOption(context, 'In Use'),
                _buildStatusOption(context, 'Available'),
                _buildStatusOption(context, 'Under Maintenance'),
                _buildStatusOption(context, 'Out of Order'),
                _buildStatusOption(context, 'Missing'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // สร้างตัวเลือกสถานะ
  Widget _buildStatusOption(BuildContext context, String status) {
    return ListTile(
      title: Text(status),
      onTap: () {
        // ทำการอัปเดตสถานะใน Repository
        // (ควรใช้ UpdateAssetUseCase)
        // ปัญหาคือไม่มีการเชื่อมต่อกับ UpdateAssetUseCase จริงๆ

        // แสดงข้อความว่าอัปเดตสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $status'),
            backgroundColor: Colors.green,
          ),
        );

        // ปิด dialog
        Navigator.of(context).pop();
      },
    );
  }
}
