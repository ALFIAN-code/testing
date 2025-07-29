class ItemPreparationDetailModel {
  final String itemRequestItemScanId;
  final String itemCodeId;
  final String itemCodeCode;
  final String itemCodeName;
  final String? itemBarcode;
  final String? itemBrand;
  final String? itemModel;
  final String? itemSerialNumber;
  final String? itemSpecification;

  ItemPreparationDetailModel({
    required this.itemRequestItemScanId,
    required this.itemCodeId,
    required this.itemCodeCode,
    required this.itemCodeName,
    this.itemBarcode,
    this.itemBrand,
    this.itemModel,
    this.itemSerialNumber,
    this.itemSpecification,
  });

  factory ItemPreparationDetailModel.fromJson(Map<String, dynamic> json) => ItemPreparationDetailModel(
      itemRequestItemScanId: json['itemRequestItemScanId'] as String,
      itemCodeId: json['itemCodeId'] as String,
      itemCodeCode: json['itemCodeCode'] as String? ?? '',
      itemCodeName: json['itemCodeName'] as String? ?? '',
      itemBarcode: json['itemBarcode'] as String?,
      itemBrand: json['itemBrand'] as String?,
      itemModel: json['itemModel'] as String?,
      itemSerialNumber: json['itemSerialNumber'] as String?,
      itemSpecification: json['itemSpecification'] as String?,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'itemRequestItemScanId': itemRequestItemScanId,
      'itemCodeId': itemCodeId,
      'itemCodeCode': itemCodeCode,
      'itemCodeName': itemCodeName,
      'itemBarcode': itemBarcode,
      'itemBrand': itemBrand,
      'itemModel': itemModel,
      'itemSerialNumber': itemSerialNumber,
      'itemSpecification': itemSpecification,
    };
}
