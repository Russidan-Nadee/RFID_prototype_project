import 'package:flutter/material.dart';
import '../database.dart';

class SearchAssetsScreen extends StatefulWidget {
  const SearchAssetsScreen({Key? key}) : super(key: key);

  @override
  State<SearchAssetsScreen> createState() => _SearchAssetsScreenState();
}

class _SearchAssetsScreenState extends State<SearchAssetsScreen> {
  final dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> assets = [];
  List<Map<String, dynamic>> filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    final data = await dbHelper.getAssets();
    setState(() {
      assets = data;
      filteredAssets = assets;
    });
  }

  void _filterAssets(String query) {
    setState(() {
      final q = query.toLowerCase();
      filteredAssets = assets.where((asset) {
        return (asset['id']?.toLowerCase().contains(q) ?? false) ||
               (asset['category']?.toLowerCase().contains(q) ?? false) ||
               (asset['status']?.toLowerCase().contains(q) ?? false) ||
               (asset['brand']?.toLowerCase().contains(q) ?? false);
      }).toList();
    });
  }

  String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.devices_other;
    switch (category.toLowerCase()) {
      case 'mouse':
        return Icons.mouse;
      case 'laptop':
        return Icons.laptop;
      case 'monitor':
        return Icons.desktop_windows;
      case 'phone':
        return Icons.phone_android;
      default:
        return Icons.devices_other;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterAssets,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAssets.length,
                itemBuilder: (context, index) {
                  final asset = filteredAssets[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ExpansionTile(
                      leading: Icon(
                        _getCategoryIcon(asset['category']),
                        size: 28,
                        color: Colors.blueGrey,
                      ),
                      title: Row(
                        children: [
                          Text(
                            asset['id'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            capitalize(asset['category']),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.qr_code, size: 20),
                            const SizedBox(width: 8),
                            Text('UID: ${asset['uid'] ?? ''}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.business, size: 20),
                            const SizedBox(width: 8),
                            Text('Brand: ${asset['brand'] ?? ''}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.apartment, size: 20),
                            const SizedBox(width: 8),
                            Text('Department: ${asset['department'] ?? ''}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.verified, size: 20),
                            const SizedBox(width: 8),
                            Text('Status: ${asset['status'] ?? ''}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}