part of 'access_permission_bloc.dart';

class AccessPermissionState extends Equatable {

  final List<AccessPermissionModel>? accessPermissions;

  const AccessPermissionState({
    this.accessPermissions,
  });

  @override
  List<Object?> get props => <Object?>[accessPermissions];

  AccessPermissionState copyWith({
    List<AccessPermissionModel>? accessPermissions,
  }) => AccessPermissionState(
    accessPermissions: accessPermissions ?? this.accessPermissions,
  );
}
