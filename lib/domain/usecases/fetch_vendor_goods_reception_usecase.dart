import '../../data/models/pagination_response_model.dart';
import '../entities/vendor_goods_reception_entity.dart';
import '../repositories/vendor_goods_reception_repository.dart';

class FetchVendorGoodsReceptionUseCase {
  final VendorGoodsReceptionRepository vendorGoodsReceptionRepository;

  FetchVendorGoodsReceptionUseCase({
    required this.vendorGoodsReceptionRepository,
  });

  Future<PaginationResponseModel<VendorGoodsReceptionEntity>> call({
    required int page,
    required int pageSize,
    String? filterByStatus,
    String? filterByVerification,
    String? searchQuery,
  }) async => await vendorGoodsReceptionRepository.fetchVendorGoodsReceptions(
    page: page,
    pageSize: pageSize,
    filterByStatus: filterByStatus,
    filterByVerification: filterByVerification,
    searchQuery: searchQuery,
  );
}
