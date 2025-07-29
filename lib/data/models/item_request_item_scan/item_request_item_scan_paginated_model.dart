import '../../../domain/entities/item_entity.dart';
import '../item/item_model.dart';
import '../item_request_item/item_request_item_model.dart';

class ItemRequestItemScanPaginatedModel {
  final String id;
  final String itemId;
  final String itemRequestItemId;
  final ItemRequestItemModel? itemRequestItem;
  final ItemModel? item;
  final DateTime createdDate;
  final int index;

  ItemRequestItemScanPaginatedModel({
    required this.id,
    required this.itemId,
    required this.itemRequestItemId,
    this.itemRequestItem,
    this.item,
    required this.createdDate,
    this.index = 0,
  });

  factory ItemRequestItemScanPaginatedModel.fromJson(Map<String, dynamic> json, {int index = 0}) => ItemRequestItemScanPaginatedModel(
        id: json['id'] as String,
        itemId: json['item_id'] as String,
        itemRequestItemId: json['item_request_item_id'] as String,
        itemRequestItem: json['item_request_item'] != null
            ? ItemRequestItemModel.fromJson(json['item_request_item'] as Map<String, dynamic>)
            : null,
        item: json['item'] != null ? ItemModel.fromJson(json['item'] as Map<String, dynamic>) : null,
        createdDate: DateTime.parse(json['created_date'] as String),
        index: index,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'itemId': itemId,
      'itemRequestItemId': itemRequestItemId,
      'itemRequestItem': itemRequestItem?.toJson(),
      'item': item?.toJson(),
      'createdDate': createdDate.toIso8601String(),
    };
}
