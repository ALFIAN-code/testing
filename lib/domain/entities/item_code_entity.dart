import '../../data/models/item_code/item_code_inspection_model.dart';
import '../../data/models/item_code/item_code_model.dart';
import '../../data/models/item_code/item_code_sync_paginated_model.dart';

class ItemCodeEntity {
  final String id;
  final String name;
  final String code;
  final String description;
  final String itemCodeCategoryId;
  final String coaId;
  final String itemClassificationId;
  final String rackCode;
  final DateTime lastUpdate;

  const ItemCodeEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.itemCodeCategoryId,
    required this.coaId,
    required this.itemClassificationId,
    required this.rackCode,
    required this.lastUpdate,
  });

  factory ItemCodeEntity.fromJson(Map<String, dynamic> json) => ItemCodeEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      description: json['description'] as String? ?? '',
      itemCodeCategoryId: json['itemCodeCategoryId'] as String,
      coaId: json['coaId'] as String,
      itemClassificationId: json['itemClassificationId'] as String,
      rackCode: json['rackCode'] as String? ?? '',
      lastUpdate: json['lastUpdate'] as DateTime,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'itemCodeCategoryId': itemCodeCategoryId,
      'coaId': coaId,
      'itemClassificationId': itemClassificationId,
      'rackCode': rackCode,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
}

extension ItemCodeSyncPaginationModelMapper on ItemCodeSyncPaginatedModel {
  ItemCodeEntity toEntity() => ItemCodeEntity(
    id: id,
    name: name,
    code: code,
    description: description,
    itemCodeCategoryId: itemCodeCategoryId,
    coaId: coaId,
    itemClassificationId: itemClassificationId,
    rackCode: rackCode,
    lastUpdate: lastUpdate,
  );
}

extension ItemCodeEntityMapper on ItemCodeEntity {
  ItemCodeModel toModel() => ItemCodeModel(
      id: id,
      name: name,
      code: code,
      description: description,
    );
}
