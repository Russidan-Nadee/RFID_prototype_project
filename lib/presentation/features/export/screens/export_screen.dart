import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/layouts/app_bottom_navigation.dart';
import '../../../common_widgets/layouts/screen_container.dart';
import '../../../common_widgets/buttons/primary_button.dart';
import '../blocs/export_bloc.dart';
import '../widgets/export_history_item.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 4; // Index for Export tab

  final List<String> exportFormats = ['CSV', 'Excel', 'PDF'];
  final List<String> availableColumns = [
    'ID',
    'Category',
    'Brand',
    'Status',
    'Date',
    'Department',
    'UID',
    'Last Scan',
  ];
  final List<String> availableStatus = [
    'All',
    'Available',
    'Checked In',
    'Checked Out',
    'Maintenance',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetBinding.instance.addPostFrameCallback((_) {
      context.read<ExportBloc>().loadPreviewData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    Navigator.pushReplacementNamed(
      context,
      ['/', '/searchAssets', '/scanRfid', '/viewAssets', '/export'][index],
    );
  }

  IconData _getFormatIcon(String format) {
    switch (format.toUpperCase()) {
      case 'CSV':
        return Icons.insert_drive_file;
      case 'EXCEL':
        return Icons.table_chart;
      case 'PDF':
        return Icons.picture_as_pdf;
      default:
        return Icons.file_present;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      usePadding: false,
      appBar: AppBar(
        title: const Text('Export Assets Data'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.tune), text: 'Options'),
            Tab(icon: Icon(Icons.preview), text: 'Preview'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Consumer<ExportBloc>(
              builder: (context, bloc, child) {
                return PrimaryButton(
                  text: 'Export Data',
                  icon: Icons.download,
                  isLoading: bloc.status == ExportStatus.exporting,
                  onPressed:
                      bloc.status == ExportStatus.exporting
                          ? null
                          : () => bloc.exportData(),
                );
              },
            ),
          ),
          AppBottomNavigation(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ],
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildExportOptions(),
          _buildDataPreview(),
          _buildExportHistory(),
        ],
      ),
    );
  }

  Widget _buildExportOptions() {
    return Consumer<ExportBloc>(
      builder: (context, bloc, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Export Format Selection
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Export Format',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children:
                          exportFormats.map((format) {
                            final isSelected = bloc.selectedFormat == format;
                            return ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getFormatIcon(format),
                                    size: 16,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(format),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  bloc.setSelectedFormat(format);
                                }
                              },
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Status Selection
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Asset Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select which asset statuses to include',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          availableStatus.map((status) {
                            final isSelected = bloc.selectedStatus.contains(
                              status,
                            );
                            return FilterChip(
                              label: Text(status),
                              selected: isSelected,
                              onSelected: (selected) {
                                bloc.toggleStatusSelection(
                                  status,
                                  availableStatus,
                                );
                              },
                              checkmarkColor: Colors.white,
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Column Selection
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Columns to Export',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          icon: Icon(
                            bloc.selectedColumns.length ==
                                    availableColumns.length
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          label: const Text('Select All'),
                          onPressed: () {
                            bloc.selectAllColumns(
                              bloc.selectedColumns.length !=
                                  availableColumns.length,
                              availableColumns,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select which data columns to include in export',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          availableColumns.map((column) {
                            final isSelected = bloc.selectedColumns.contains(
                              column,
                            );
                            return FilterChip(
                              label: Text(column),
                              selected: isSelected,
                              onSelected: (selected) {
                                bloc.toggleColumnSelection(column);
                              },
                              checkmarkColor: Colors.white,
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataPreview() {
    return Consumer<ExportBloc>(
      builder: (context, bloc, child) {
        if (bloc.status == ExportStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bloc.previewAssets.isEmpty) {
          return const Center(
            child: Text(
              'No data available for preview',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Data Preview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    onPressed: () => bloc.loadPreviewData(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: MaterialStateProperty.all(
                      Colors.grey.shade100,
                    ),
                    columns:
                        bloc.selectedColumns.map((column) {
                          return DataColumn(
                            label: Text(
                              column,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                    rows:
                        bloc.previewAssets.map((asset) {
                          return DataRow(
                            cells:
                                bloc.selectedColumns.map((column) {
                                  String value = '';
                                  switch (column.toLowerCase()) {
                                    case 'id':
                                      value = asset.id;
                                      break;
                                    case 'category':
                                      value = asset.category;
                                      break;
                                    case 'status':
                                      value = asset.status;
                                      break;
                                    case 'brand':
                                      value = asset.brand;
                                      break;
                                    case 'department':
                                      value = asset.department;
                                      break;
                                    case 'uid':
                                      value = asset.uid;
                                      break;
                                    case 'date':
                                      value = asset.date;
                                      break;
                                    default:
                                      value = '-';
                                  }
                                  return DataCell(Text(value));
                                }).toList(),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Note: Preview shows first 5 records only',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExportHistory() {
    return Consumer<ExportBloc>(
      builder: (context, bloc, child) {
        if (bloc.exportHistory.isEmpty) {
          return const Center(
            child: Text(
              'No export history available',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bloc.exportHistory.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ExportHistoryItem(
              exportData: bloc.exportHistory[index],
              formatIcon: _getFormatIcon(bloc.exportHistory[index]['format']),
              onDownload: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Downloading ${bloc.exportHistory[index]['filename']}...',
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
