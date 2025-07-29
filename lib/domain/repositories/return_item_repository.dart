abstract class ReturnItemRepository {
  Future<String> scanItem(String barcode);
  Future<void> cancelRequest(String requestId);
  Future<void> sync();
  Future<int> getNotSyncYet();
}