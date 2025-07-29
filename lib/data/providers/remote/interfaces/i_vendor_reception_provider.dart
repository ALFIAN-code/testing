import 'package:dio/dio.dart';

import '../../../models/pagination_response_model.dart';
import '../../../models/vendor_goods_reception_model.dart';

abstract class IVendorReceptionProvider {
  Future<PaginationResponseModel<VendorGoodsReceptionModel>>
      getVendorGoodsReceptions({
    required int page,
    required int pageSize,
    String? filterByStatus,
    String? filterByVerification,
    String? searchQuery,
  });

  Future<VendorGoodsReceptionModel?> getVendorGoodsReceptionById(String id);

  Future<Response<dynamic>> updateVendorGoodsReceptionStatus({
    required String id,
    required String status,
    String? verificationStatus,
  });
}
