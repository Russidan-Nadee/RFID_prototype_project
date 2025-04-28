import 'package:flutter/material.dart';
import '../database.dart'; // ดึงฐานข้อมูลมาใช้

class search_page extends StatefulWidget {
  const search_page({super.key});

  @override
  State<search_page> createState() => _search_pageState();
}

class _search_pageState extends State<search_page> {
  final dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> assets = [];

  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  void loadAssets() async {
    final data = await dbHelper.getAssets();
    setState(() {
      assets = data;
    });
  }

  List<Map<String, dynamic>> get filteredAssets {
    if (_searchController.text.isEmpty) {
      return assets;
    } else {
      final searchText = _searchController.text.toLowerCase();
      return assets.where((asset) {
        return (asset['id']?.toString().toLowerCase().contains(searchText) ?? false) ||
               (asset['category']?.toLowerCase().contains(searchText) ?? false) ||
               (asset['brand']?.toLowerCase().contains(searchText) ?? false) ||
               (asset['uid']?.toLowerCase().contains(searchText) ?? false) ||
               (asset['status']?.toLowerCase().contains(searchText) ?? false);
      }).toList();
    }
  }

  // เพิ่มฟังก์ชันโชว์ dialog
  void showAssetDetails(Map<String, dynamic> asset) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Asset Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${asset['id']}'),
                Text('UID: ${asset['uid']}'),
                Text('Category: ${asset['category']}'),
                Text('Brand: ${asset['brand']}'),
                Text('Department: ${asset['department']}'),
                Text('Status: ${asset['status']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Assets")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search anything...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {}); // พอพิมพ์ก็อัปเดตทันที
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAssets.length,
              itemBuilder: (context, index) {
                final asset = filteredAssets[index];
                return ListTile(
                  title: Text("${asset['id']} - ${asset['category'] ?? ''}"),
                  subtitle: Text("Brand: ${asset['brand'] ?? ''}\nUID: ${asset['uid'] ?? ''}"),
                  isThreeLine: true,
                  onTap: () {
                    showAssetDetails(asset); // คลิกแล้วเปิด Dialog
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
