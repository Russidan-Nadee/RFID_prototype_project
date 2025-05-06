import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfid_project/presentation/features/rfid/screens/developer_options_screen.dart';
import '../../../common_widgets/inputs/text_input.dart';
import '../../../common_widgets/buttons/primary_button.dart';
import '../../../common_widgets/layouts/app_bottom_navigation.dart';
import '../../../common_widgets/layouts/screen_container.dart';
import '../blocs/rfid_scan_bloc.dart';

class ScanRfidScreen extends StatefulWidget {
  const ScanRfidScreen({Key? key}) : super(key: key);

  @override
  State<ScanRfidScreen> createState() => _ScanRfidScreenState();
}

class _ScanRfidScreenState extends State<ScanRfidScreen> {
  final TextEditingController _uidController = TextEditingController();
  int _selectedIndex = 2; // Index for the Scan tab

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    Navigator.pushReplacementNamed(
      context,
      [
        '/',
        '/searchAssets',
        '/scanRfid',
        '/viewAssets',
        '/export',
      ][index], // ควรใช้ NavigationConstants.tabRoutes[index] แทน
    );
  }

  // ฟังก์ชันสำหรับเปิดหน้าตั้งค่าการจำลอง
  void _openDeveloperOptions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                const DeveloperOptionsScreen(), // แทน DeveloperOptionsPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      appBar: AppBar(
        title: const Text('Scan RFID'),
        actions: [
          // ปุ่มสำหรับเปิดหน้าตั้งค่าการจำลอง (สำหรับนักพัฒนา)
          Consumer<RfidScanBloc>(
            builder: (context, bloc, child) {
              if (bloc.isMockMode) {
                return IconButton(
                  icon: const Icon(Icons.developer_mode),
                  onPressed: _openDeveloperOptions,
                  tooltip: 'Developer Options',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      child: Consumer<RfidScanBloc>(
        builder: (context, bloc, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UID input field
                TextInput(
                  controller: _uidController,
                  label: 'Enter UID or Asset ID',
                  hint: 'Enter 10-character UID',
                  prefixIcon: Icons.qr_code,
                  maxLength: 10,
                ),

                const SizedBox(height: 16),

                // Error message if any
                if (bloc.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      bloc.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // แสดงโหมดการจำลองปัจจุบัน (สำหรับนักพัฒนา)
                if (bloc.isMockMode)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Mock Mode: ${bloc.mockMode.toString().split('.').last}',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),

                // ปุ่มสแกนด้วย UID ที่กรอกเข้ามา
                PrimaryButton(
                  text: 'Scan with UID',
                  icon: Icons.input,
                  isLoading: bloc.status == RfidScanStatus.scanning,
                  onPressed: () {
                    bloc.scanWithManualUid(_uidController.text, context);
                  },
                ),

                const SizedBox(height: 16),

                // ปุ่มสแกน RFID จริง (หรือจำลอง)
                PrimaryButton(
                  text: 'Scan RFID',
                  icon: Icons.qr_code_scanner,
                  isLoading: bloc.status == RfidScanStatus.scanning,
                  onPressed: () {
                    bloc.scanRfid(context);
                  },
                ),

                const SizedBox(height: 32),

                // Additional instructions
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Scan an RFID tag or enter the UID manually to locate assets in the system.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
