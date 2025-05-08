import 'package:flutter/foundation.dart';
import './search_event.dart';
import './search_state.dart';
import '../../../services/asset_service/data/repositories/asset_repository_impl.dart';
import '../../../services/asset_service/domain/entities/asset.dart';

class SearchBloc extends ChangeNotifier {
  final AssetRepositoryImpl _repository;

  SearchState _state = SearchInitial();
  SearchState get state => _state;

  String _query = '';
  String get query => _query;

  SearchBloc(this._repository);

  Future<void> add(SearchEvent event) async {
    if (event is SearchQueryEvent) {
      await _handleSearchQueryEvent(event.query);
    } else if (event is ClearSearchEvent) {
      _handleClearSearchEvent();
    }
  }

  Future<void> _handleSearchQueryEvent(String query) async {
    _query = query;

    if (query.isEmpty) {
      _state = SearchInitial();
      notifyListeners();
      return;
    }

    _state = SearchLoading();
    notifyListeners();

    try {
      // ดึงข้อมูลสินทรัพย์ทั้งหมด
      final assets = await _repository.getAssets();

      // กรองจากคำค้นหา (แบบง่าย)
      final results = _filterAssets(assets, query);

      if (results.isEmpty) {
        _state = SearchEmpty();
      } else {
        _state = SearchSuccess(results);
      }
    } catch (e) {
      _state = SearchFailure(e.toString());
    }

    notifyListeners();
  }

  void _handleClearSearchEvent() {
    _query = '';
    _state = SearchInitial();
    notifyListeners();
  }

  // ฟังก์ชันช่วยกรองสินทรัพย์ตามคำค้นหา
  List<Asset> _filterAssets(List<Asset> assets, String query) {
    query = query.toLowerCase();

    return assets.where((asset) {
      return asset.id.toLowerCase().contains(query) ||
          asset.category.toLowerCase().contains(query) ||
          asset.brand.toLowerCase().contains(query) ||
          asset.uid.toLowerCase().contains(query) ||
          asset.department.toLowerCase().contains(query);
    }).toList();
  }

  // สร้างเหตุการณ์จากหน้าจอโดยตรงโดยไม่ต้องสร้าง instance ของ Event

  Future<void> search(String query) async {
    await add(SearchQueryEvent(query));
  }

  void clearSearch() {
    add(ClearSearchEvent());
  }
}
