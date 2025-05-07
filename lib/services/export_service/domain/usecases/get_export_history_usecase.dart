import '../entities/export_record.dart';
import '../repositories/export_repository.dart';

class GetExportHistoryUseCase {
  final ExportRepository _repository;

  GetExportHistoryUseCase(this._repository);

  Future<List<ExportRecord>> execute() async {
    return await _repository.getExportHistory();
  }
}
