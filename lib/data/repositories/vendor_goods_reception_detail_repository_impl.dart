import '../../domain/entities/vendor_goods_reception_detail_entity.dart';
import '../../domain/repositories/vendor_goods_reception_detail_repository.dart';
import '../providers/remote/implementations/remote_vendor_reception_provider_detail.dart';

class VendorGoodsReceptionDetailRepositoryImpl
    implements VendorGoodsReceptionDetailRepository {
  final RemoteVendorGoodsReceptionDetailProvider remoteVendorGoodsReceptionDetailProvider;

  VendorGoodsReceptionDetailRepositoryImpl({
    required this.remoteVendorGoodsReceptionDetailProvider,
  });

  @override
  Future<VendorGoodsReceptionDetailEntity> fetchVendorGoodsReceptionDetail({
    required String receptionId,
    required int page,
    required int pageSize,
    String? sortField,
    bool? sortAscending,
  }) async => remoteVendorGoodsReceptionDetailProvider.getVendorGoodsReceptionDetail(
    receptionId: receptionId,
    page: page,
    pageSize: pageSize,
    sortField: sortField,
    sortAscending: sortAscending,
  );
}
