class ItemStatisticConditionModel {
  final String? id;
  final String name;
  final String code;
  final int total;
  final double percentage;

  ItemStatisticConditionModel({
    this.id,
    required this.name,
    required this.code,
    required this.total,
    required this.percentage,
  });

  factory ItemStatisticConditionModel.fromJson(Map<String, dynamic> json) => ItemStatisticConditionModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      percentage: (json['percentage'] as num? ?? 0).toDouble(),
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'total': total,
      'percentage': percentage,
    };
}
