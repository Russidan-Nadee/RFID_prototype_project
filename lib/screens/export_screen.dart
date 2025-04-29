import 'package:flutter/material.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  List<String> selectedColumns = [
    'ID',
    'Category',
    'Brand',
    'Status',
    'Date',
  ]; // คอลัมน์เริ่มต้น

  List<String> selectedStatus = [
    'All',
  ]; // สถานะเริ่มต้น (ใช้เป็น list เพื่อรองรับหลายค่า)

  bool isSelectAll = true; // ติ๊ก Select All ตั้งแต่เริ่มต้น

  // ฟังก์ชันสำหรับการเลือกทั้งหมด
  void _toggleSelectAll(bool? value) {
    setState(() {
      isSelectAll = value ?? false;
      if (isSelectAll) {
        selectedColumns = ['ID', 'Category', 'Brand', 'Status', 'Date']; // เลือกคอลัมน์ทั้งหมด
      } else {
        selectedColumns = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header for Status Selection
            Center(
              child: const Text(
                'Select Status to Export',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            MultiSelectStatus(
              ['All', 'Available', 'Checked In'],
              selectedStatus,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedStatus = selectedList;
                });
              },
            ),
            const SizedBox(height: 20),

            // Header for Column Selection
            Center(
              child: const Text(
                'Select Columns to Export',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Select All Columns Button (เริ่มต้นจะติ๊ก)
            CheckboxListTile(
              title: const Text('Select All Columns'),
              value: isSelectAll,
              onChanged: _toggleSelectAll,
            ),

            // MultiSelect for Columns
            MultiSelectChip(
              ['ID', 'Category', 'Brand', 'Status', 'Date'],
              selectedColumns,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedColumns = selectedList;
                  // ถ้าคอลัมน์ย่อยๆ ถูกยกเลิกทั้งหมด ก็ให้ยกเลิก Select All ด้วย
                  isSelectAll = selectedList.length == 5;
                });
              },
            ),
            const SizedBox(height: 40),

            // Export Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // ยังไม่ทำการส่งออก
                },
                child: const Text(
                  'Export Data',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget สำหรับให้เลือกหลายๆ สถานะ
class MultiSelectStatus extends StatelessWidget {
  final List<String> availableStatus;
  final List<String> selectedStatus;
  final Function(List<String>) onSelectionChanged;

  MultiSelectStatus(
    this.availableStatus,
    this.selectedStatus, {
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: availableStatus.map((status) {
        return CheckboxListTile(
          title: Text(status),
          value: selectedStatus.contains(status),
          onChanged: (bool? isSelected) {
            List<String> selectedList = List.from(selectedStatus);
            if (isSelected == true) {
              selectedList.add(status);
            } else {
              selectedList.remove(status);
            }
            onSelectionChanged(selectedList);
          },
        );
      }).toList(),
    );
  }
}

// Widget สำหรับให้เลือกหลายๆ คอลัมน์
class MultiSelectChip extends StatelessWidget {
  final List<String> availableColumns;
  final List<String> selectedColumns;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(
    this.availableColumns,
    this.selectedColumns, {
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children:
          availableColumns.map((column) {
            return CheckboxListTile(
              title: Text(column),
              value: selectedColumns.contains(column),
              onChanged: (bool? isSelected) {
                List<String> selectedList = List.from(selectedColumns);
                if (isSelected == true) {
                  selectedList.add(column);
                } else {
                  selectedList.remove(column);
                }
                onSelectionChanged(selectedList);
              },
            );
          }).toList(),
    );
  }
}
