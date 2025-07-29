import 'pagination_model.dart';

class PaginationResponseModel<T> {
  final List<T> items;
  final PaginationModel pagination;

  PaginationResponseModel({required this.items, required this.pagination});

  factory PaginationResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final List<T> itemsList =
        (json['items'] as List<dynamic>?)
            ?.map((dynamic item) => fromJsonT(item as Map<String, dynamic>))
            .toList() ??
        <T>[];
    final Map<String, dynamic>? paginationData =
        json['pagination'] as Map<String, dynamic>?;

    if (paginationData == null) {
      throw const FormatException('Pagination data is missing in the response');
    }

    return PaginationResponseModel<T>(
      items: itemsList,
      pagination: PaginationModel.fromJson(paginationData),
    );
  }
}
