import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/layouts/screen_container.dart';
import '../../../common_widgets/buttons/primary_button.dart';
import '../blocs/export_bloc.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
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

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      appBar: AppBar(title: const Text('Export Assets Data'), elevation: 0),
      child: Consumer<ExportBloc>(
        builder: (context, bloc, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select columns to export',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: availableColumns.length,
                  itemBuilder: (context, index) {
                    final column = availableColumns[index];
                    final isSelected = bloc.selectedColumns.contains(column);

                    return CheckboxListTile(
                      title: Text(column),
                      value: isSelected,
                      onChanged: (value) {
                        if (value != null) {
                          bloc.toggleColumnSelection(column);
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: PrimaryButton(
                  text: 'Export Data',
                  icon: Icons.download,
                  onPressed: () {}, // ปุ่มกดไม่ได้ตามที่ต้องการ
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
