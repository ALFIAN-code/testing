import '../entities/vendor_goods_reception_detail_entity.dart';

abstract class VendorGoodsReceptionDetailRepository {
  Future<VendorGoodsReceptionDetailEntity> fetchVendorGoodsReceptionDetail({
    required String receptionId,
    required int page,
    required int pageSize,
    String? sortField,
    bool? sortAscending,
  });
}
