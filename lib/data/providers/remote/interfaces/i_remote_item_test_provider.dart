import '../../../models/item/item_maintenance_model.dart';
import '../../../models/item/item_test_model.dart';
import '../../../request/item_test/create_item_test_request.dart';

abstract class IRemoteItemTestProvider {
  Future<ItemTestModel> getDetailBarcode(String barcode);
  Future<void> update(String barcode, CreateItemTestRequest request);
  Future<List<ItemMaintenanceModel>> getHistories(String barcode);
}