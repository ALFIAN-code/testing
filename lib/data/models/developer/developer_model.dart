class DeveloperModel {
  final String id;
  final String name;
  final String code;
  final String phone;

  DeveloperModel({
    required this.id,
    required this.name,
    required this.code,
    required this.phone,
  });

  factory DeveloperModel.fromJson(Map<String, dynamic> json) => DeveloperModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => <String, String>{
      'id': id,
      'name': name,
      'code': code,
      'phone': phone,
    };
}
