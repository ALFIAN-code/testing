abstract class IRemoteReturnItemProvider {
  Future<void> scanItem(String barcode);
  Future<void> bulkScan(List<String> barcode);
}