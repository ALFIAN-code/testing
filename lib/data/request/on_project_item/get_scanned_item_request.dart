class GetScannedItemListRequest {
  final String projectId;
  final bool isScanned;
  final String search;

  GetScannedItemListRequest({
    required this.projectId,
    this.isScanned = true,
    this.search = '',
  });

  Map<String, dynamic> toJson() => {
    'projectId': projectId,
    'isScanned': isScanned,
    'search': search,
  };

  GetScannedItemListRequest copyWith({
    String? projectId,
    bool? isScanned,
    String? search,
  }) => GetScannedItemListRequest(
      projectId: projectId ?? this.projectId,
      isScanned: isScanned ?? this.isScanned,
      search: search ?? this.search,
    );
}
