import '../../domain/repositories/item_test_repository.dart';
import '../models/item/item_maintenance_model.dart';
import '../models/item/item_test_model.dart';
import '../providers/remote/interfaces/i_remote_item_test_provider.dart';
import '../request/item_test/create_item_test_request.dart';

class ItemTestRepositoryImpl implements ItemTestRepository {

  final IRemoteItemTestProvider remoteItemTestProvider;

  ItemTestRepositoryImpl(this.remoteItemTestProvider);

  @override
  Future<ItemTestModel> getDetailBarcode(String barcode) => remoteItemTestProvider.getDetailBarcode(barcode);

  @override
  Future<void> update(String barcode, CreateItemTestRequest request) => remoteItemTestProvider.update(barcode, request);

  @override
  Future<List<ItemMaintenanceModel>> getHistories(String barcode) => remoteItemTestProvider.getHistories(barcode);
}