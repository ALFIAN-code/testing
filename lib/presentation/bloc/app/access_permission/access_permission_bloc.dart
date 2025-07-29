import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/access_permission_model.dart';


part 'access_permission_state.dart';

class AccessPermissionBloc extends Cubit<AccessPermissionState> {
  AccessPermissionBloc() : super(const AccessPermissionState());

  void setPermissions(List<AccessPermissionModel> permissions) {
    emit(state.copyWith(accessPermissions: permissions));
  }

  bool hasAccess(String module, String action) {
    final List<AccessPermissionModel>? permissions = state.accessPermissions;

    if (permissions == null || permissions.isEmpty) return false;

    final AccessPermissionModel permission = permissions.firstWhere(
          (AccessPermissionModel e) => e.module == module,
      orElse: () => AccessPermissionModel(module: module),
    );

    switch (action.toLowerCase()) {
      case 'view':
        return permission.view;
      case 'insert':
        return permission.insert;
      case 'update':
        return permission.update;
      case 'upsert':
        return permission.upsert;
      case 'delete':
        return permission.delete;
      case 'history':
        return permission.history;
      default:
        return false;
    }
  }
}
