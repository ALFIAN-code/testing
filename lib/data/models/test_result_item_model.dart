import '../../domain/entities/test_result_item_entity.dart';

class TestResultItemModel {
  final String id;
  final String code;
  final String itemId;
  final DateTime scannedDate;

  TestResultItemModel({
    required this.id,
    required this.code,
    required this.itemId,
    required this.scannedDate,
  });

  factory TestResultItemModel.fromMap(Map<String, dynamic> map) => TestResultItemModel(
    id: map['id'] as String,
    code: map['code'] as String,
    itemId: map['itemId'] as String,
    scannedDate: DateTime.parse(map['scannedDate'] as String),
  );

  Map<String, dynamic> toMap() => <String, Object>{
    'id': id,
    'code': code,
    'itemId': itemId,
    'scannedDate': scannedDate.toIso8601String(),
  };

}

extension TestResultItemModelMapper on TestResultItemModel {
  TestResultItemEntity toEntity() => TestResultItemEntity(
      id: id,
      code: code,
      itemId: itemId,
      scannedDate: scannedDate,
    );
}

extension TestResultItemEntityMapper on TestResultItemEntity {
  TestResultItemModel toModel() => TestResultItemModel(
    id: id,
    code: code,
    itemId: itemId,
    scannedDate: scannedDate,
  );
}