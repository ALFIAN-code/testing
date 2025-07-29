import 'city_type_model.dart';

class CityModel {
  String id;
  String countryId;
  String cityTypeId;
  CityTypeModel? cityType;
  String provinceId;
  String code;
  String name;

  CityModel({
    required this.id,
    required this.countryId,
    required this.cityTypeId,
    this.cityType,
    required this.provinceId,
    required this.code,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json['id'] as String,
    countryId: json['countryId'] as String,
    cityTypeId: json['cityTypeId'] as String,
    cityType: json['cityType'] != null
        ? CityTypeModel.fromJson(json['cityType'] as Map<String, dynamic>)
        : null,
    provinceId: json['provinceId'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'countryId': countryId,
    'cityTypeId': cityTypeId,
    'cityType': cityType?.toJson(),
    'provinceId': provinceId,
    'code': code,
    'name': name,
  };
}
