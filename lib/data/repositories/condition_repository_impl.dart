import '../../domain/entities/condition_entity.dart';
import '../../domain/repositories/condition_repository.dart';
import '../mappers/condition_mapper.dart';
import '../models/base_list_request_model.dart';
import '../models/condition/condition_paginated_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/local/interfaces/i_local_condition_provider.dart';
import '../providers/remote/interfaces/i_remote_condition_provider.dart';

class ConditionRepositoryImpl implements ConditionRepository {

  final IRemoteConditionProvider remoteConditionProvider;
  final ILocalConditionProvider localConditionProvider;

  ConditionRepositoryImpl(this.remoteConditionProvider, this.localConditionProvider);

  @override
  Future<PaginationResponseModel<ConditionPaginatedModel>> getList(BaseListRequestModel model) => remoteConditionProvider.getList(model);

  @override
  Future<void> sync() async {
    try {
      final PaginationResponseModel<ConditionPaginatedModel> result = await remoteConditionProvider
          .getList(BaseListRequestModel.initial(pageSize: 20));
      if (result.items.isNotEmpty) {
        await localConditionProvider.deleteAll();
        final List<ConditionEntity> items = result.items.map((ConditionPaginatedModel e) => e.toEntity()).toList();
        await localConditionProvider.upsertBatch(items);
      }
    } catch(_) {
      return;
    }
  }

  @override
  Future<List<ConditionPaginatedModel>> getListLocal() async {
    final List<ConditionEntity> items = await localConditionProvider.getAll();
    return items.map((ConditionEntity e) => e.toPaginatedModel()).toList();
  }
}