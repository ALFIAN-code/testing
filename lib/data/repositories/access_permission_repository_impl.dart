import '../../domain/entities/access_permission_entity.dart';
import '../../domain/repositories/access_permission_repository.dart';
import '../models/access_permission_model.dart';
import '../providers/local/implementations/local_access_permission_provider.dart';

class AccessPermissionRepositoryImpl implements AccessPermissionRepository {

  final LocalAccessPermissionProvider localAccessPermissionProvider;

  AccessPermissionRepositoryImpl(this.localAccessPermissionProvider);

  @override
  Future<List<AccessPermissionModel>> getAll() async {
    try {
      final List<AccessPermissionEntity> result = await localAccessPermissionProvider.getAll();

      return result.map((AccessPermissionEntity e) => AccessPermissionModel.fromEntity(e)).toList();

    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> insertRange(List<AccessPermissionModel> models) async {
    final List<AccessPermissionEntity> entities = models
        .map((AccessPermissionModel e) => e.toEntity()).toList();
    await localAccessPermissionProvider.insertRange(entities);
  }

  @override
  Future<void> deleteAll() async => localAccessPermissionProvider.deleteAll();
}