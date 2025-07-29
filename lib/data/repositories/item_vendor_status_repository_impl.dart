import '../../domain/repositories/item_vendor_status_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/item_vendor_status/item_vendor_status_paginated_model.dart';
import '../models/pagination_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/remote/interfaces/i_remote_item_vendor_status_provider.dart';

class ItemVendorStatusRepositoryImpl implements ItemVendorStatusRepository {

  final IRemoteItemVendorStatusProvider remoteItemVendorStatusProvider;

  ItemVendorStatusRepositoryImpl({required this.remoteItemVendorStatusProvider});

  @override
  Future<PaginationResponseModel<ItemVendorStatusPaginatedModel>> getList(BaseListRequestModel model) => remoteItemVendorStatusProvider.getList(model);
}