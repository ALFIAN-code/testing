import '../../data/models/item/item_maintenance_model.dart';
import '../../data/models/item/item_test_model.dart';
import '../../data/request/item_test/create_item_test_request.dart';

abstract class ItemTestRepository {
  Future<ItemTestModel> getDetailBarcode(String barcode);
  Future<void> update(String barcode, CreateItemTestRequest request);
  Future<List<ItemMaintenanceModel>> getHistories(String barcode);
}