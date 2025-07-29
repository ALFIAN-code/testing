class ItemPreparationSummaryRequest {
  final String projectId;
  final String search;
  final String? itemRequestId;

  ItemPreparationSummaryRequest({
    required this.projectId,
    required this.search,
    required this.itemRequestId,
  });

  factory ItemPreparationSummaryRequest.fromJson(Map<String, dynamic> json) => ItemPreparationSummaryRequest(
      projectId: json['projectId'] as String,
      search: json['search'] as String,
      itemRequestId: json['itemRequestId'] as String,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'projectId': projectId,
      'search': search,
      'itemRequestId': itemRequestId,
    };
}
