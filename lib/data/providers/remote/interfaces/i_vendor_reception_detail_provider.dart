import '../../../models/vendor_goods_reception_detail_model.dart';

abstract class IVendorReceptionDetailProvider {
  Future<VendorGoodsReceptionDetailModel> getVendorGoodsReceptionDetail({
    required String receptionId,
    required int page,
    required int pageSize,
    String? sortField,
    bool? sortAscending,
  });
}
