import '../../domain/entities/item_code_entity.dart';
import '../../domain/repositories/item_code_repository.dart';
import '../models/item_code/item_code_sync_paginated_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/local/interfaces/i_local_item_code_provider.dart';
import '../providers/remote/interfaces/i_remote_item_code_provider.dart';

class ItemCodeRepositoryImpl implements ItemCodeRepository {

  final IRemoteItemCodeProvider _remoteItemCodeProvider;
  final ILocalItemCodeProvider _localItemCodeProvider;

  ItemCodeRepositoryImpl(this._remoteItemCodeProvider, this._localItemCodeProvider);

  @override
  Future<void> sync() async {
    try {
      final ItemCodeEntity? lastEntity = await _localItemCodeProvider.getLatest();
      final String date = lastEntity?.lastUpdate != null
          ? lastEntity!.lastUpdate.toUtc().toIso8601String()
          : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toIso8601String();

      final PaginationResponseModel<ItemCodeSyncPaginatedModel> result = await _remoteItemCodeProvider.sync(lastEntity?.id, date);
      if (result.items.isNotEmpty) {
        final List<ItemCodeEntity> entities = result.items.map((e) => e.toEntity()).toList();
        await _localItemCodeProvider.upsertBatch(entities);
      }
    }catch(e) {
      return;
    }
  }

}