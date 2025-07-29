class TestResultItemEntity {
  final String id;
  final String code;
  final String itemId;
  final DateTime scannedDate;

  TestResultItemEntity({
    required this.id,
    required this.code,
    required this.itemId,
    required this.scannedDate,
  });

  factory TestResultItemEntity.fromMap(Map<String, dynamic> map) => TestResultItemEntity(
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
