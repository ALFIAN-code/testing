class EmployeeModel {
  final String id;
  final String name;
  final String code;
  final String phone;
  final String address;
  final String genderCode;
  final DateTime birthDate;
  final DateTime hiredDate;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.code,
    required this.phone,
    required this.address,
    required this.genderCode,
    required this.birthDate,
    required this.hiredDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      genderCode: json['genderCode'] as String? ?? '',
      birthDate: DateTime.parse(json['birthDate'] as String),
      hiredDate: DateTime.parse(json['hiredDate'] as String),
    );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'phone': phone,
      'address': address,
      'genderCode': genderCode,
      'birthDate': birthDate.toIso8601String(),
      'hiredDate': hiredDate.toIso8601String(),
    };
  }
}
