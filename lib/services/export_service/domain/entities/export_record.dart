enum ExportFormat { csv, excel, pdf, json }

class ExportRecord {
  final int id;
  final String filename;
  final ExportFormat format;
  final int recordCount;
  final DateTime exportDate;
  final String? generatedBy;
  final String? filePath;

  ExportRecord({
    required this.id,
    required this.filename,
    required this.format,
    required this.recordCount,
    required this.exportDate,
    this.generatedBy,
    this.filePath,
  });

  Map<String, dynamic> toJson() {
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

  factory ExportRecord.fromJson(Map<String, dynamic> json) {
    return ExportRecord(
      id: json['id'],
      filename: json['filename'],
      format: _formatFromString(json['format']),
      recordCount: json['recordCount'],
      exportDate: DateTime.parse(json['exportDate']),
      generatedBy: json['generatedBy'],
      filePath: json['filePath'],
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
