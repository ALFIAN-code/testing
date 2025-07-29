class ReturnItemScanEntity {
  final String id;
  final String itemBarcode;

  ReturnItemScanEntity({
    required this.id,
    required this.itemBarcode,
  });

  factory ReturnItemScanEntity.fromJson(Map<String, dynamic> json) =>
      ReturnItemScanEntity(
        id: json['id'] as String,
        itemBarcode: json['itemBarcode'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'itemBarcode': itemBarcode,
      };
}