import 'package:flutter/material.dart';
import 'package:rfid_project/screens/rifd_scan.dart';
import 'package:rfid_project/screens/search_page.dart';
import 'package:rfid_project/screens/view_assets.dart';

class home_page extends StatelessWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF), // สีพื้นหลังม่วงอ่อน
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDashboardButton(
                title: 'RFID Scan Reader',
                color: Colors.lightBlue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const rifd_scan()),
                  );
                },
              ),
              _buildDashboardButton(
                title: 'View Assets',
                color: Colors.lightBlue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const view_assets(),
                    ),
                  );
                },
              ),
              _buildDashboardButton(
                title: 'Search Assets',
                color: Colors.lightBlue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const search_page(),
                    ),
                  );
                },
              ),
              _buildDashboardButton(
                title: 'Export Audit Data',
                color: Colors.grey,
                disabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton({
    required String title,
    required Color color,
    VoidCallback? onPressed,
    bool disabled = false,
  }) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 8,
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            shadowColor: Colors.black45, // เพิ่มเงานุ่ม ๆ
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
