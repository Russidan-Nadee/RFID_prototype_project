import 'package:flutter/material.dart';
import '../../../../domain/entities/asset.dart';

class AssetTableRow {
  final Asset asset;
  final int index;

  AssetTableRow({required this.asset, required this.index});

  DataRow getRow() {
    final isChecked = asset.status == 'Checked In';

    return DataRow(
      color: MaterialStateProperty.all(
        index.isEven ? Colors.grey.shade100 : Colors.white,
      ),
      cells: [
        DataCell(Center(child: Text(asset.id))),
        DataCell(Center(child: Text(asset.category))),
        DataCell(Center(child: Text(asset.status))),
        DataCell(Center(child: Checkbox(value: isChecked, onChanged: null))),
      ],
    );
  }
}
