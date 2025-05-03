import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/layouts/app_bottom_navigation.dart';
import '../../../common_widgets/layouts/screen_container.dart';
import '../blocs/asset_bloc.dart';
import '../widgets/asset_table_row.dart';

class ViewAssetsScreen extends StatefulWidget {
  const ViewAssetsScreen({Key? key}) : super(key: key);

  @override
  _ViewAssetsScreenState createState() => _ViewAssetsScreenState();
}

class _ViewAssetsScreenState extends State<ViewAssetsScreen> {
  int _selectedIndex = 3; // Index for the View tab

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetBloc>().loadAssets();
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    Navigator.pushReplacementNamed(
      context,
      ['/', '/searchAssets', '/scanRfid', '/viewAssets', '/export'][index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      appBar: AppBar(title: const Text('View Assets')),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      child: Consumer<AssetBloc>(
        builder: (context, bloc, child) {
          if (bloc.status == AssetStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (bloc.status == AssetStatus.error) {
            return Center(child: Text('Error: ${bloc.errorMessage}'));
          } else if (bloc.assets.isEmpty) {
            return const Center(
              child: Text(
                'No assets available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action')),
                ],
                rows: List.generate(
                  bloc.assets.length,
                  (index) =>
                      AssetTableRow(
                        asset: bloc.assets[index],
                        index: index,
                      ).getRow(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
