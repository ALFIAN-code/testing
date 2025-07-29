final class LogInspectionEntity {
  final String id;
  final String itemId;

  LogInspectionEntity({
    required this.id,
    required this.itemId,
  });

  factory LogInspectionEntity.fromJson(Map<String, dynamic> json) => LogInspectionEntity(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
    );

  Map<String, dynamic> toJson() =>
      {'id': id, 'itemId': itemId};
}