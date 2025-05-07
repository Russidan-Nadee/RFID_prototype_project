class PaginationModel<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginationModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final List<dynamic> itemsJson = json['items'] ?? [];
    final List<T> items = itemsJson.map((item) => fromJson(item)).toList();

    return PaginationModel(
      items: items,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? items.length,
      totalItems: json['totalItems'] ?? items.length,
      totalPages: json['totalPages'] ?? 1,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map((item) => toJsonT(item)).toList(),
      'page': page,
      'pageSize': pageSize,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }
}
