import '../../domain/entities/vendor_goods_reception_entity.dart';
import '../../domain/repositories/vendor_goods_reception_repository.dart';
import '../models/pagination_response_model.dart';
import '../providers/remote/implementations/remote_vendor_reception_provider.dart';

class VendorGoodsReceptionRepositoryImpl
    implements VendorGoodsReceptionRepository {
  final RemoteVendorGoodsReceptionProvider remoteVendorGoodsReceptionProvider;

  VendorGoodsReceptionRepositoryImpl({
    required this.remoteVendorGoodsReceptionProvider,
  });

  @override
  Future<PaginationResponseModel<VendorGoodsReceptionEntity>>
  fetchVendorGoodsReceptions({
    required int page,
    required int pageSize,
    String? filterByStatus,
    String? filterByVerification,
    String? searchQuery,
  }) async => remoteVendorGoodsReceptionProvider.getVendorGoodsReceptions(
    page: page,
    pageSize: pageSize,
    filterByStatus: filterByStatus,
    filterByVerification: filterByVerification,
    searchQuery: searchQuery,
  );

  @override
  Future<VendorGoodsReceptionEntity?> fetchVendorGoodsReceptionById(
    String id,
  ) async => remoteVendorGoodsReceptionProvider.getVendorGoodsReceptionById(id);
}
