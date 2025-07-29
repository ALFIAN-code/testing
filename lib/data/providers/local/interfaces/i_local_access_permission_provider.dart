import '../../../../domain/entities/access_permission_entity.dart';

abstract class ILocalAccessPermissionProvider {
  Future<void> insertRange(List<AccessPermissionEntity> entities);
  Future<List<AccessPermissionEntity>> getAll();
  Future<void> deleteAll();
}