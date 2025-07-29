import '../../domain/repositories/item_vendor_reception_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/item_vendor_reception/item_vendor_reception_item_paginated_model.dart';
import '../models/item_vendor_reception/item_vendor_reception_model.dart';
import '../models/item_vendor_reception/item_vendor_reception_paginated_model.dart';
import '../models/item_vendor_reception/item_vendor_reception_param.dart';
import '../models/pagination_response_model.dart';
import '../providers/remote/interfaces/i_remote_item_vendor_reception_provider.dart';

class ItemVendorReceptionRepositoryImpl implements ItemVendorReceptionRepository {

  final IRemoteItemVendorReceptionProvider remoteItemVendorReceptionProvider;

  ItemVendorReceptionRepositoryImpl({required this.remoteItemVendorReceptionProvider});

  @override
  Future<PaginationResponseModel<ItemVendorReceptionPaginatedModel>> getList(BaseListRequestModel model) => remoteItemVendorReceptionProvider.getList(model);

  @override
  Future<ItemVendorReceptionModel> getDetail(String id) => remoteItemVendorReceptionProvider.getDetail(id);

  @override
  Future<PaginationResponseModel<ItemVendorReceptionItemPaginatedModel>> getListItem(String id, BaseListRequestModel model) {
    try {
      final Future<PaginationResponseModel<ItemVendorReceptionItemPaginatedModel>> result = remoteItemVendorReceptionProvider.getListItem(id, model);
      return result;
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> updateChecklist(String id, ItemVendorReceptionParam param) => remoteItemVendorReceptionProvider.updateChecklist(id, param);
}