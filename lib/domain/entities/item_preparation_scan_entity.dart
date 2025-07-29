class ItemPreparationScanEntity {
  final String id;
  final String projectId;
  final String itemBarcode;

  ItemPreparationScanEntity({
    required this.id,
    required this.projectId,
    required this.itemBarcode,
  });

  factory ItemPreparationScanEntity.fromJson(Map<String, dynamic> json) =>
      ItemPreparationScanEntity(
        id: json['id'] as String,
        projectId: json['projectId'] as String,
        itemBarcode: json['itemBarcode'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'projectId': projectId,
        'itemBarcode': itemBarcode,
      };
}