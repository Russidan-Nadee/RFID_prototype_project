import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rfid_project/domain/usecases/assets/get_assets_usecase.dart';
import '../../../../domain/entities/asset.dart';

enum AssetStatus { initial, loading, loaded, error }

class AssetBloc extends ChangeNotifier {
  final GetAssetsUseCase _getAssetsUseCase;

  AssetStatus _status = AssetStatus.initial;
  List<Asset> _assets = [];
  List<Asset> _filteredAssets = [];
  String _errorMessage = '';
  String _searchQuery = '';

  AssetBloc(this._getAssetsUseCase);

  AssetStatus get status => _status;
  List<Asset> get assets => _assets;
  List<Asset> get filteredAssets => _filteredAssets;
  String get errorMessage => _errorMessage;

  Future<void> loadAssets() async {
    _status = AssetStatus.loading;
    notifyListeners();

    try {
      final assets = await _getAssetsUseCase.execute();
      _assets = assets;
      _applyFilter();
      _status = AssetStatus.loaded;
    } catch (e) {
      _status = AssetStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredAssets = List.from(_assets);
      return;
    }

    final query = _searchQuery.toLowerCase();
    _filteredAssets =
        _assets.where((asset) {
          return asset.id.toLowerCase().contains(query) ||
              asset.category.toLowerCase().contains(query) ||
              asset.status.toLowerCase().contains(query) ||
              asset.brand.toLowerCase().contains(query);
        }).toList();
  }
}
