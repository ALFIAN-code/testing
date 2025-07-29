import '../../domain/repositories/item_vendor_checklist_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/item_vendor_checklist/item_vendor_checklist_paginated_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/remote/interfaces/i_remote_item_vendor_checklist_provider.dart';

class ItemVendorChecklistRepositoryImpl implements ItemVendorChecklistRepository {

  final IRemoteItemVendorChecklistProvider remoteItemVendorChecklistProvider;

  ItemVendorChecklistRepositoryImpl({required this.remoteItemVendorChecklistProvider});

  @override
  Future<PaginationResponseModel<ItemVendorChecklistPaginatedModel>> getList(BaseListRequestModel model) => remoteItemVendorChecklistProvider.getList(model);
}