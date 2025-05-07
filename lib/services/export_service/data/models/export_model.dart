import '../../domain/entities/export_record.dart';

class ExportModel extends ExportRecord {
  ExportModel({
    required int id,
    required String filename,
    required ExportFormat format,
    required int recordCount,
    required DateTime exportDate,
    String? generatedBy,
    String? filePath,
  }) : super(
         id: id,
         filename: filename,
         format: format,
         recordCount: recordCount,
         exportDate: exportDate,
         generatedBy: generatedBy,
         filePath: filePath,
       );

  factory ExportModel.fromMap(Map<String, dynamic> map) {
    return ExportModel(
      id: map['id'],
      filename: map['filename'],
      format: _formatFromString(map['format']),
      recordCount: map['recordCount'],
      exportDate: DateTime.parse(map['exportDate']),
      generatedBy: map['generatedBy'],
      filePath: map['filePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filename': filename,
      'format': format.toString().split('.').last,
      'recordCount': recordCount,
      'exportDate': exportDate.toIso8601String(),
      'generatedBy': generatedBy,
      'filePath': filePath,
    };
  }

  factory ExportModel.fromEntity(ExportRecord entity) {
    return ExportModel(
      id: entity.id,
      filename: entity.filename,
      format: entity.format,
      recordCount: entity.recordCount,
      exportDate: entity.exportDate,
      generatedBy: entity.generatedBy,
      filePath: entity.filePath,
    );
  }

  static ExportFormat _formatFromString(String format) {
    switch (format.toLowerCase()) {
      case 'csv':
        return ExportFormat.csv;
      case 'excel':
        return ExportFormat.excel;
      case 'pdf':
        return ExportFormat.pdf;
      case 'json':
        return ExportFormat.json;
      default:
        return ExportFormat.csv;
    }
  }
}
