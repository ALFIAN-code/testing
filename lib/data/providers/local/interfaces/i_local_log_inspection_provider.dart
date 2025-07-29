import '../../../../domain/entities/log_inspection_entity.dart';

abstract class ILocalLogInspectionProvider {
  Future<void> insert(LogInspectionEntity entity);
  Future<void> deleteBatch(List<String> ids);
  Future<List<LogInspectionEntity>> getAll();
  Future<LogInspectionEntity?> getById(String id);
  Future<void> truncate();
}