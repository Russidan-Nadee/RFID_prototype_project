import 'package:flutter/material.dart';
import '../database.dart';

class view_assets extends StatefulWidget {
  const view_assets({super.key});

  @override
  _view_assetsState createState() => _view_assetsState();
}

class _view_assetsState extends State<view_assets> {
  final dbHelper = DatabaseHelper();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Assets")),
      body: assets.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: assets.map((asset) {
                    return DataRow(cells: [
                      DataCell(Text(asset['id'].toString())),
                      DataCell(Text(asset['category'] ?? '')),
                      DataCell(Text(asset['status'] ?? '')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
