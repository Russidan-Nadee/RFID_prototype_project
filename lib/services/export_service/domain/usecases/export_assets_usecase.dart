import '../entities/export_record.dart';
import '../repositories/export_repository.dart';

class ExportAssetsUseCase {
  final ExportRepository _repository;

  ExportAssetsUseCase(this._repository);

  Future<ExportRecord> execute(
    ExportFormat format,
    List<String> columns,
    List<String>? statuses,
  ) async {
    return await _repository.exportAssets(format, columns, statuses);
  }
}
