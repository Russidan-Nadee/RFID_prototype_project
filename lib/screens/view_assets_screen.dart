import 'package:flutter/material.dart';
import '../database.dart';

class ViewAssetsScreen extends StatefulWidget {
  const ViewAssetsScreen({Key? key}) : super(key: key);

  @override
  State<ViewAssetsScreen> createState() => _ViewAssetsScreenState();
}

class _ViewAssetsScreenState extends State<ViewAssetsScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> assets = [];
  String filter = '';

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    final data = await dbHelper.getAssets();
    setState(() => assets = data);
  }

  @override
  Widget build(BuildContext context) {
    final displayed =
        filter.isEmpty
            ? assets
            : assets
                .where(
                  (a) =>
                      a['id']?.toLowerCase().contains(filter.toLowerCase()) ==
                          true ||
                      a['category']?.toLowerCase().contains(
                            filter.toLowerCase(),
                          ) ==
                          true,
                )
                .toList();

    return Scaffold(
      body:
          assets.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with subtle rounding
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Assets ID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                child: Text(
                                  'Category',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 23.0,
                              ), // กำหนดระยะห่างจากซ้าย
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Data table with same corner radius
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowHeight: 0,
                            dataRowHeight: 60,
                            columnSpacing: 12,
                            columns: const [
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox(width: 24)),
                            ],
                            rows: List.generate(displayed.length, (index) {
                              final asset = displayed[index];
                              final isChecked = asset['status'] == 'Checked In';
                              return DataRow(
                                color: MaterialStateProperty.all(
                                  index.isEven
                                      ? Colors.grey.shade100
                                      : Colors.white,
                                ),
                                cells: [
                                  DataCell(
                                    Center(child: Text(asset['id'] ?? '-')),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(asset['category'] ?? '-'),
                                    ),
                                  ),
                                  DataCell(
                                    Center(child: Text(asset['status'] ?? '-')),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Checkbox(
                                        value: isChecked,
                                        onChanged: null,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
