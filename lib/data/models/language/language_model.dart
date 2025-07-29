class LanguageModel {
  final String id;
  final String name;
  final String code;

  LanguageModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
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
