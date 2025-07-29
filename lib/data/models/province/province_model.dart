class ProvinceModel {
  String id;
  String countryId;
  String code;
  String name;
  String shortName;

  ProvinceModel({
    required this.id,
    required this.countryId,
    required this.code,
    required this.name,
    required this.shortName,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
    id: json['id'] as String,
    countryId: json['countryId'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    shortName: json['shortName'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'countryId': countryId,
    'code': code,
    'name': name,
    'shortName': shortName,
  };
}
