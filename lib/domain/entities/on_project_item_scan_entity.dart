class OnProjectItemScanEntity {
  final String id;
  final String projectId;
  final String itemBarcode;

  OnProjectItemScanEntity({
    required this.id,
    required this.projectId,
    required this.itemBarcode,
  });

  factory OnProjectItemScanEntity.fromJson(Map<String, dynamic> json) =>
      OnProjectItemScanEntity(
        id: json['id'] as String,
        projectId: json['projectId'] as String,
        itemBarcode: json['itemBarcode'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'projectId': projectId,
        'itemBarcode': itemBarcode,
      };
}