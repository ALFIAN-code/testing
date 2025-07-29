class ScannedItemListModel {
  final String itemCodeId;
  final String itemCodeCode;
  final String itemCodeName;
  final String itemId;
  final String itemBarcode;
  final String itemRequestItemScanId;

  ScannedItemListModel({
    required this.itemCodeId,
    required this.itemCodeCode,
    required this.itemCodeName,
    required this.itemId,
    required this.itemBarcode,
    required this.itemRequestItemScanId
  });

  factory ScannedItemListModel.fromJson(Map<String, dynamic> json) => ScannedItemListModel(
      itemCodeId: json['itemCodeId'] as String,
      itemCodeCode: json['itemCodeCode'] as String? ?? '',
      itemCodeName: json['itemCodeName'] as String? ?? '',
      itemId: json['itemId'] as String,
      itemBarcode: json['itemBarcode'] as String? ?? '',
      itemRequestItemScanId: json['itemRequestItemScanId'] as String? ?? ''
    );

  Map<String, dynamic> toJson() => {
      'itemCodeId': itemCodeId,
      'itemCodeCode': itemCodeCode,
      'itemCodeName': itemCodeName,
      'itemId': itemId,
      'itemBarcode': itemBarcode,
      'itemRequestItemScanId': itemRequestItemScanId
    };
}
