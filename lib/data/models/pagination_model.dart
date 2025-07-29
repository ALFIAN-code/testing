class PaginationModel {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  PaginationModel({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, Object?> json) =>
      PaginationModel(
        currentPage: json['page'] as int,
        pageSize: json['pageSize'] as int,
        totalItems: json['totalItems'] as int,
        totalPages: json['totalPages'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'currentPage': currentPage,
    'pageSize': pageSize,
    'totalItems': totalItems,
    'totalPages': totalPages,
  };
}
