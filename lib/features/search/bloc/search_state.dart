import '../../../services/asset_service/domain/entities/asset.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Asset> results;

  SearchSuccess(this.results);
}

class SearchEmpty extends SearchState {}

class SearchFailure extends SearchState {
  final String message;

  SearchFailure(this.message);
}
