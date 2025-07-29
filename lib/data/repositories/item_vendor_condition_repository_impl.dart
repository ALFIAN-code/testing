import '../../domain/repositories/item_vendor_condition_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/item_vendor_condition/item_vendor_condition_paginated_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/remote/interfaces/i_remote_item_vendor_condition_provider.dart';

class ItemVendorConditionRepositoryImpl implements ItemVendorConditionRepository {

  final IRemoteItemVendorConditionProvider remoteItemVendorConditionProvider;

  ItemVendorConditionRepositoryImpl({required this.remoteItemVendorConditionProvider});

  @override
  Future<PaginationResponseModel<ItemVendorConditionPaginatedModel>> getList(BaseListRequestModel model) => remoteItemVendorConditionProvider.getList(model);
}