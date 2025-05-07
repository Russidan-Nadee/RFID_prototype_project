import '../entities/export_record.dart';

abstract class ExportRepository {
  Future<List<ExportRecord>> getExportHistory();
  Future<ExportRecord> exportAssets(
    ExportFormat format,
    List<String> columns,
    List<String>? statuses,
  );
  Future<String?> getExportFilePath(int exportId);
  Future<void> deleteExport(int exportId);
}
