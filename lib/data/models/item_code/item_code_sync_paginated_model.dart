class ItemCodeSyncPaginatedModel {
  final int index;
  final String id;
  final String name;
  final String code;
  final String description;
  final String itemCodeCategoryId;
  final String coaId;
  final String itemClassificationId;
  final String rackCode;
  final DateTime lastUpdate;

  ItemCodeSyncPaginatedModel({
    required this.index,
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

  factory ItemCodeSyncPaginatedModel.fromJson(Map<String, dynamic> json, {int index = 0}) => ItemCodeSyncPaginatedModel(
      index: index,
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      description: json['description'] as String? ?? '',
      itemCodeCategoryId: json['itemCodeCategoryId'] as String,
      coaId: json['coaId'] as String,
      itemClassificationId: json['itemClassificationId'] as String,
      rackCode: json['rackCode'] as String? ?? '',
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'index': index,
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
