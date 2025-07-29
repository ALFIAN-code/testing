
import '../city/city_model.dart';
import '../province/province_model.dart';

class SupplierModel {
  String id;
  String name;
  String code;
  String? taxId;
  String? phone;
  String? address;
  String? provinceId;
  String? cityId;
  String? bankName;
  String? bankAccountName;
  String? bankAccountNumber;
  ProvinceModel? province;
  CityModel? city;

  SupplierModel({
    required this.id,
    required this.name,
    required this.code,
    this.taxId,
    this.phone,
    this.address,
    this.provinceId,
    this.cityId,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.province,
    this.city,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String,
    taxId: json['taxId'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    provinceId: json['provinceId'] as String?,
    cityId: json['cityId'] as String?,
    bankName: json['bankName'] as String?,
    bankAccountName: json['bankAccountName'] as String?,
    bankAccountNumber: json['bankAccountNumber'] as String?,
    province: json['province'] != null
        ? ProvinceModel.fromJson(json['province'] as Map<String, dynamic>)
        : null,
    city: json['city'] != null ? CityModel.fromJson(json['city'] as Map<String, dynamic>) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'taxId': taxId,
    'phone': phone,
    'address': address,
    'provinceId': provinceId,
    'cityId': cityId,
    'bankName': bankName,
    'bankAccountName': bankAccountName,
    'bankAccountNumber': bankAccountNumber,
    'province': province?.toJson(),
    'city': city?.toJson(),
  };
}
