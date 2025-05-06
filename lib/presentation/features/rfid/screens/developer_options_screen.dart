import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/rfid_scan_bloc.dart';
import '../widgets/mock_mode_selector.dart';

class DeveloperOptionsScreen extends StatelessWidget {
  const DeveloperOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Developer Options')),
      body: Consumer<RfidScanBloc>(
        builder: (context, bloc, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RFID Mock Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // ตัวเลือกโหมดการจำลอง
                MockModeSelector(
                  currentMode: bloc.mockMode,
                  onModeChanged: (mode) {
                    bloc.mockMode = mode;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Mock Mode Explanation:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // คำอธิบายโหมดต่างๆ
                _buildModeExplanation(
                  'Normal',
                  'Random results. Sometimes finds assets, sometimes not.',
                ),
                _buildModeExplanation(
                  'Found',
                  'Always simulates finding an asset in the system.',
                ),
                _buildModeExplanation(
                  'Not Found',
                  'Always simulates finding a tag that is not in the system.',
                ),
                _buildModeExplanation(
                  'Scan Failed',
                  'Always simulates a failed scan (no tag found).',
                ),

                const SizedBox(height: 32),

                // ปุ่มยกเลิก
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeExplanation(String mode, String explanation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$mode: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(explanation)),
        ],
      ),
    );
  }
}
