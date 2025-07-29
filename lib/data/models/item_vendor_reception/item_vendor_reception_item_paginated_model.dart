import '../item_code/item_code_model.dart';

class ItemVendorReceptionItemPaginatedModel {

  final int index;
  final String id;
  final int amount;
  final String itemCodeId;
  final String itemVendorId;
  final ItemCodeModel? itemCode;

  ItemVendorReceptionItemPaginatedModel({
    required this.index,
    required this.id,
    required this.amount,
    required this.itemCodeId,
    required this.itemVendorId,
    this.itemCode,
  });

  factory ItemVendorReceptionItemPaginatedModel.fromJson(Map<String, dynamic> json) => ItemVendorReceptionItemPaginatedModel(
      index: json['index'] as int,
      id: json['id'] as String,
      amount: json['amount'] as int,
      itemCodeId: json['itemCodeId'] as String,
      itemVendorId: json['itemVendorId'] as String,
      itemCode: json['itemCode'] != null
          ? ItemCodeModel.fromJson(json['itemCode'] as Map<String, dynamic>)
          : null,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'index': index,
      'id': id,
      'amount': amount,
      'itemCodeId': itemCodeId,
      'itemVendorId': itemVendorId,
      if (itemCode != null) 'itemCode': itemCode!.toJson(),
    };
}
