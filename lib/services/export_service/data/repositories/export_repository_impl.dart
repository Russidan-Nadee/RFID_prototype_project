// services/export_service/data/repositories/export_repository_impl.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart' as path;
import '../../domain/entities/export_record.dart';
import '../../domain/repositories/export_repository.dart';
import '../datasources/local/export_database.dart';
import 'package:rfid_project/shared/interfaces/asset_service_client_interface.dart';
import '../models/export_model.dart';

class ExportRepositoryImpl implements ExportRepository {
  final ExportDatabase _exportDatabase;
  final AssetServiceClientInterface _assetServiceClient;

  ExportRepositoryImpl(this._exportDatabase, this._assetServiceClient);

  @override
  Future<List<ExportRecord>> getExportHistory() async {
    try {
      final exportMaps = await _exportDatabase.getExportHistory();
      return exportMaps.map((map) => ExportModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการดึงประวัติการส่งออก: $e');
    }
  }

  @override
  Future<ExportRecord> exportAssets(
    ExportFormat format,
    List<String> columns,
    List<String>? statuses,
  ) async {
    try {
      // ดึงข้อมูลสินทรัพย์ตามเงื่อนไข
      final assets = await _assetServiceClient.getFilteredAssets(statuses);

      // กำหนดชื่อไฟล์และนามสกุล
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _getFileExtension(format);
      final filename = 'asset_export_$timestamp.$extension';

      // สร้างไฟล์ส่งออก
      final filePath = await _createExportFile(
        assets,
        columns,
        format,
        filename,
      );

      // บันทึกประวัติการส่งออก
      final exportRecord = ExportModel(
        id: 0, // ให้ฐานข้อมูลกำหนด ID เอง
        filename: filename,
        format: format,
        recordCount: assets.length,
        exportDate: DateTime.now(),
        generatedBy: 'System',
        filePath: filePath,
      );

      final id = await _exportDatabase.insertExportRecord(exportRecord.toMap());

      return exportRecord.copyWith(id: id);
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการส่งออกสินทรัพย์: $e');
    }
  }

  @override
  Future<String?> getExportFilePath(int exportId) async {
    try {
      final exportMap = await _exportDatabase.getExportById(exportId);
      if (exportMap == null) return null;

      return exportMap['filePath'] as String?;
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการดึงพาธของไฟล์ส่งออก: $e');
    }
  }

  @override
  Future<void> deleteExport(int exportId) async {
    try {
      // ลบไฟล์
      final exportMap = await _exportDatabase.getExportById(exportId);
      if (exportMap != null && exportMap['filePath'] != null) {
        final file = File(exportMap['filePath']);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // ลบข้อมูลในฐานข้อมูล
      await _exportDatabase.deleteExport(exportId);
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการลบการส่งออก: $e');
    }
  }

  // ฟังก์ชันช่วยสร้างไฟล์ส่งออก
  Future<String> _createExportFile(
    List<Map<String, dynamic>> assets,
    List<String> columns,
    ExportFormat format,
    String filename,
  ) async {
    // สร้างโฟลเดอร์สำหรับเก็บไฟล์ส่งออก
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final filePath = path.join(exportDir.path, filename);

    switch (format) {
      case ExportFormat.csv:
        return _createCsvFile(assets, columns, filePath);
      case ExportFormat.excel:
        return _createExcelFile(assets, columns, filePath);
      case ExportFormat.pdf:
        return _createPdfFile(assets, columns, filePath);
      case ExportFormat.json:
        return _createJsonFile(assets, columns, filePath);
      default:
        throw Exception('รูปแบบการส่งออกไม่รองรับ');
    }
  }

  // สร้างไฟล์ CSV
  Future<String> _createCsvFile(
    List<Map<String, dynamic>> assets,
    List<String> columns,
    String filePath,
  ) async {
    final csvData = [
      columns, // หัวตาราง
      ...assets.map((asset) => columns.map((col) => asset[col] ?? '').toList()),
    ];

    final csvString = const ListToCsvConverter().convert(csvData);
    final file = File(filePath);
    await file.writeAsString(csvString);

    return filePath;
  }

  // สร้างไฟล์ Excel
  Future<String> _createExcelFile(
    List<Map<String, dynamic>> assets,
    List<String> columns,
    String filePath,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Assets'];

    // เพิ่มหัวตาราง
    for (var i = 0; i < columns.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = columns[i]
        ..cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
        );
    }

    // เพิ่มข้อมูลสินทรัพย์
    for (var i = 0; i < assets.length; i++) {
      for (var j = 0; j < columns.length; j++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
          ..value = assets[i][columns[j]] ?? '';
      }
    }

    // บันทึกไฟล์
    final bytes = excel.encode();
    final file = File(filePath);
    await file.writeAsBytes(bytes!);

    return filePath;
  }

  // สร้างไฟล์ PDF (ตัวอย่างง่ายๆ)
  Future<String> _createPdfFile(
    List<Map<String, dynamic>> assets,
    List<String> columns,
    String filePath,
  ) async {
    // ในกรณีจริงต้องใช้ไลบรารีสร้าง PDF เช่น pdf, flutter_pdf, etc.
    // นี่เป็นเพียงตัวอย่างง่ายๆ

    final buffer = StringBuffer();
    buffer.writeln('Asset Export PDF');
    buffer.writeln('Columns: ${columns.join(', ')}');
    buffer.writeln('Total records: ${assets.length}');
    buffer.writeln('Generated at: ${DateTime.now()}');

    final file = File(filePath);
    await file.writeAsString(buffer.toString());

    return filePath;
  }

  // สร้างไฟล์ JSON
  Future<String> _createJsonFile(
    List<Map<String, dynamic>> assets,
    List<String> columns,
    String filePath,
  ) async {
    // กรองเฉพาะคอลัมน์ที่ต้องการ
    final filteredAssets =
        assets.map((asset) {
          final filteredAsset = <String, dynamic>{};
          for (var column in columns) {
            filteredAsset[column] = asset[column];
          }
          return filteredAsset;
        }).toList();

    final jsonString = json.encode(filteredAssets);
    final file = File(filePath);
    await file.writeAsString(jsonString);

    return filePath;
  }

  String _getFileExtension(ExportFormat format) {
    switch (format) {
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.excel:
        return 'xlsx';
      case ExportFormat.pdf:
        return 'pdf';
      case ExportFormat.json:
        return 'json';
      default:
        return 'csv';
    }
  }
}

// ขยาย ExportModel
extension ExportModelExtension on ExportModel {
  ExportModel copyWith({
    int? id,
    String? filename,
    ExportFormat? format,
    int? recordCount,
    DateTime? exportDate,
    String? generatedBy,
    String? filePath,
  }) {
    return ExportModel(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      format: format ?? this.format,
      recordCount: recordCount ?? this.recordCount,
      exportDate: exportDate ?? this.exportDate,
      generatedBy: generatedBy ?? this.generatedBy,
      filePath: filePath ?? this.filePath,
    );
  }
}
