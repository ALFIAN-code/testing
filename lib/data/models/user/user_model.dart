import '../developer/developer_model.dart';
import '../employee/employee_model.dart';
import '../language/language_model.dart';
import '../zone/zone_model.dart';

class UserModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final LanguageModel? language;
  final ZoneModel? zone;
  final DeveloperModel? developer;
  final EmployeeModel? employee;
  final bool isSuper;
  final String? image;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.language,
    this.zone,
    this.developer,
    this.employee,
    required this.isSuper,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      language: json['language'] != null ? LanguageModel.fromJson(json['language'] as Map<String, dynamic>) : null,
      zone: json['zone'] != null ? ZoneModel.fromJson(json['zone'] as Map<String, dynamic>) : null,
      developer: json['developer'] != null ? DeveloperModel.fromJson(json['developer'] as Map<String, dynamic>) : null,
      employee: json['employee'] != null ? EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>) : null,
      isSuper: json['isSuper'] as bool? ?? false,
      image: json['image'] as String?,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'language': language?.toJson(),
      'zone': zone?.toJson(),
      'developer': developer?.toJson(),
      'employee': employee?.toJson(),
      'isSuper': isSuper,
      'image': image,
    };
}
