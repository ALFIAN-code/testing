import '../role/role_model.dart';

class UserInfoModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String image;
  final List<RoleModel> roles;

  UserInfoModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.image,
    required this.roles,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      image: json['image'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'name': name,
    'email': email,
    'image': image,
    'roles': roles.map((e) => e.toJson()).toList(),
  };
}
