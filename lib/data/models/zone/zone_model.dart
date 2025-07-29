class ZoneModel {
  final String id;
  final String offset;
  final int? offsetMinute;
  final String label;
  final String tzCode;

  ZoneModel({
    required this.id,
    required this.offset,
    this.offsetMinute,
    required this.label,
    required this.tzCode,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) => ZoneModel(
      id: json['id'] as String,
      offset: json['offset'] as String? ?? '',
      offsetMinute: json['offsetMinute'] as int?,
      label: json['label'] as String? ?? '',
      tzCode: json['tzCode'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'offset': offset,
      'offsetMinute': offsetMinute,
      'label': label,
      'tzCode': tzCode,
    };
}
