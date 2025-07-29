class CityTypeModel {
  String id;
  String name;

  CityTypeModel({
    required this.id,
    required this.name,
  });

  factory CityTypeModel.fromJson(Map<String, dynamic> json) => CityTypeModel(
    id: json['id'] as String,
    name: json['name'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
