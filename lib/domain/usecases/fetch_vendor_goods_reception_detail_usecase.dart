import '../entities/vendor_goods_reception_detail_entity.dart';
import '../repositories/vendor_goods_reception_detail_repository.dart';

class FetchVendorGoodsReceptionDetailUseCase {
  final VendorGoodsReceptionDetailRepository
  vendorGoodsReceptionDetailRepository;

  FetchVendorGoodsReceptionDetailUseCase({
    required this.vendorGoodsReceptionDetailRepository,
  });

  Future<VendorGoodsReceptionDetailEntity> call({
    required String receptionId,
    required int page,
    required int pageSize,
    String? sortField,
    bool? sortAscending,
  }) => vendorGoodsReceptionDetailRepository.fetchVendorGoodsReceptionDetail(
    receptionId: receptionId,
    page: page,
    pageSize: pageSize,
    sortField: sortField,
    sortAscending: sortAscending,
  );
}
