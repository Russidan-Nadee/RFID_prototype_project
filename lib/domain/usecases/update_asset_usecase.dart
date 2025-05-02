import 'package:flutter/material.dart';
import '../repositories/asset_repository.dart';

class UpdateAssetUseCase {
  final AssetRepository repository;

  UpdateAssetUseCase(this.repository);

  Future<bool> execute(String uid, String status) async {
    return await repository.updateAssetStatus(uid, status);
  }
}
