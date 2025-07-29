import '../../data/models/pagination_response_model.dart';
import '../entities/vendor_goods_reception_entity.dart';

abstract class VendorGoodsReceptionRepository {
  Future<PaginationResponseModel<VendorGoodsReceptionEntity>> fetchVendorGoodsReceptions({
    required int page,
    required int pageSize,
    String? filterByStatus,
    String? filterByVerification,
    String? searchQuery,
  });
  Future<VendorGoodsReceptionEntity?> fetchVendorGoodsReceptionById(String id);
}
