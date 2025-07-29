import '../../data/models/access_permission_model.dart';

abstract class AccessPermissionRepository {
  Future<void> insertRange(List<AccessPermissionModel> models);
  Future<List<AccessPermissionModel>> getAll();
  Future<void> deleteAll();
}