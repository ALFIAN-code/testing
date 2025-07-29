class ProjectPaginatedModel {
  final String id;
  final String name;
  final String address;
  final String code;
  final String picName;
  // final CountryModel? country;
  // final ProvinceModel? province;
  // final DistrictModel? district;
  // final SubDistrictModel? subDistrict;
  final DateTime startDate;
  final DateTime? endDate;
  // final CompanyModel? company;
  // final ProjectEmployeePicModel? employeePic;

  const ProjectPaginatedModel({
    required this.id,
    required this.name,
    required this.address,
    required this.code,
    required this.picName,
    // this.country,
    // this.province,
    // this.district,
    // this.subDistrict,
    required this.startDate,
    this.endDate,
    // this.company,
    // this.employeePic,
  });

  factory ProjectPaginatedModel.fromJson(Map<String, dynamic> json) => ProjectPaginatedModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      code: json['code'] as String? ?? '',
      picName: json['picName'] as String? ?? '',
      // country: json['country'] != null ? CountryModel.fromJson(json['country'] as Map<String, dynamic>) : null,
      // province: json['province'] != null ? ProvinceModel.fromJson(json['province'] as Map<String, dynamic>) : null,
      // district: json['district'] != null ? DistrictModel.fromJson(json['district'] as Map<String, dynamic>) : null,
      // subDistrict: json['subDistrict'] != null ? SubDistrictModel.fromJson(json['subDistrict'] as Map<String, dynamic>) : null,
      startDate: DateTime.parse(json['startDate'] as String? ?? ''),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      // company: json['company'] != null ? CompanyModel.fromJson(json['company'] as Map<String, dynamic>) : null,
      // employeePic: json['employeePic'] != null ? ProjectEmployeePicModel.fromJson(json['employeePic'] as Map<String, dynamic>) : null,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'code': code,
      'picName': picName,
      // 'country': country?.toJson(),
      // 'province': province?.toJson(),
      // 'district': district?.toJson(),
      // 'subDistrict': subDistrict?.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      // 'company': company?.toJson(),
      // 'employeePic': employeePic?.toJson(),
    };
}
