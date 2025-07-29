class DeliveryStatusModel {
  final String id;
  final String name;
  final String code;

  DeliveryStatusModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory DeliveryStatusModel.fromJson(Map<String, dynamic> json) => DeliveryStatusModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => <String, String>{
      'id': id,
      'name': name,
      'code': code,
    };
}
