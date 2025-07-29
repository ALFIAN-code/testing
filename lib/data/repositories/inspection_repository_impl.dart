import 'package:uuid/uuid.dart';

import '../../domain/entities/log_inspection_entity.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../providers/local/interfaces/i_local_log_inspection_provider.dart';
import '../providers/remote/interfaces/i_remote_inspection_provider.dart';

class InspectionRepositoryImpl implements InspectionRepository {

  final ILocalLogInspectionProvider _localInspectionProvider;
  final IRemoteInspectionProvider _remoteInspectionProvider;

  InspectionRepositoryImpl(this._localInspectionProvider, this._remoteInspectionProvider);

  @override
  Future<void> logInspection(String itemId) async {
    try {
      await _localInspectionProvider.insert(LogInspectionEntity(
          id: const Uuid().v4(), itemId: itemId),);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<int> getNotSyncYet() async {
    int total = 0;
    try {
      final List<LogInspectionEntity> list = await _localInspectionProvider.getAll();
      total = list.length;
      return total;
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> sync() async {
    try {
      final List<LogInspectionEntity> list = await _localInspectionProvider.getAll();

      if (list.isEmpty) return;

      await _remoteInspectionProvider.bulkScan(list.map((LogInspectionEntity e) => e.itemId).toList());
      await _localInspectionProvider.deleteBatch(list.map((LogInspectionEntity e) => e.id).toList());
    } catch(e) {
      rethrow;
    }
  }
}