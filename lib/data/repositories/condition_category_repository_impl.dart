import '../../domain/entities/condition_category_entity.dart';
import '../../domain/repositories/condition_category_repository.dart';
import '../mappers/condition_category_mapper.dart';
import '../models/base_list_request_model.dart';
import '../models/condition_category/condition_category_paginated_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/local/interfaces/i_local_condition_category_provider.dart';
import '../providers/remote/interfaces/i_remote_condition_category_provider.dart';

class ConditionCategoryRepositoryImpl implements ConditionCategoryRepository {

  final IRemoteConditionCategoryProvider remoteConditionCategoryProvider;
  final ILocalConditionCategoryProvider localConditionCategoryProvider;

  ConditionCategoryRepositoryImpl(this.remoteConditionCategoryProvider, this.localConditionCategoryProvider);

  @override
  Future<PaginationResponseModel<ConditionCategoryPaginatedModel>> getList(BaseListRequestModel model) => remoteConditionCategoryProvider.getList(model);

  @override
  Future<void> sync() async {
    try {
      final PaginationResponseModel<ConditionCategoryPaginatedModel> result = await remoteConditionCategoryProvider
          .getList(BaseListRequestModel.initial(pageSize: 20));
      if (result.items.isNotEmpty) {
        await localConditionCategoryProvider.deleteAll();
        final List<ConditionCategoryEntity> items = result.items.map((ConditionCategoryPaginatedModel e) => e.toEntity()).toList();
        await localConditionCategoryProvider.upsertBatch(items);
      }
    } catch(_) {
      return;
    }
  }

  @override
  Future<List<ConditionCategoryPaginatedModel>> getListLocal() async {
    final List<ConditionCategoryEntity> items = await localConditionCategoryProvider.getAll();
    return items.map((ConditionCategoryEntity e) => e.toPaginatedModel()).toList();
  }
}