abstract class SearchEvent {}

class SearchQueryEvent extends SearchEvent {
  final String query;

  SearchQueryEvent(this.query);
}

class ClearSearchEvent extends SearchEvent {}
