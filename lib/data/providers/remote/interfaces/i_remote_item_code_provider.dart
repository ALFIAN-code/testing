import '../../../models/item_code/item_code_sync_paginated_model.dart';
import '../../../models/pagination_response_model.dart';

abstract class IRemoteItemCodeProvider {
  Future<PaginationResponseModel<ItemCodeSyncPaginatedModel>> sync(String? id, String? lastUpdate);
}