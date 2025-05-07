import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../corewait/constants/route_constants.dart';
import '../../../common_widgets/buttons/primary_button.dart';
import '../../../common_widgets/layouts/screen_container.dart';
import '../blocs/rfid_scan_bloc.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rfidScanBloc = Provider.of<RfidScanBloc>(context);

    return ScreenContainer(
      // เพิ่ม AppBar เหมือนหน้า Found
      appBar: AppBar(title: const Text('ไม่พบอุปกรณ์')),
      child: Column(
        children: [
          // ส่วนแสดงสถานะด้านบน
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ไม่พบอุปกรณ์ในระบบ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'UID: ${rfidScanBloc.randomAssetInfo?.uid ?? "Unknown"}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // แสดงข้อมูลสินทรัพย์
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildInfoCard(rfidScanBloc),
            ),
          ),

          // ปุ่มด้านล่าง
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                PrimaryButton(
                  text: 'Add new Asset',
                  icon: Icons.add_circle_outline,
                  onPressed: () async {
                    // เรียกใช้ createAsset แทน generateNewRandomAsset
                    final success = await rfidScanBloc.createAsset();
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Asset บันทึกเรียบร้อยแล้ว'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      rfidScanBloc.resetStatus();
                      Navigator.pushNamed(context, RouteConstants.scanRfid);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('เกิดข้อผิดพลาดในการบันทึก Asset'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Back to Scanner',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    rfidScanBloc.resetStatus();
                    Navigator.pushNamed(context, RouteConstants.scanRfid);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(RfidScanBloc bloc) {
    final infoData = bloc.randomAssetInfo;

    if (infoData == null) {
      return const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('ไม่มีข้อมูล'),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดง ID ที่ด้านบนและทำให้เด่น
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  infoData.id,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            _buildInfoRow('หมวดหมู่:', infoData.category),
            _buildInfoRow('แบรนด์:', infoData.brand),
            _buildInfoRow('แผนก:', infoData.department),
            _buildInfoRow('สถานะ:', infoData.status),
            _buildInfoRow('วันที่:', infoData.date),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
