abstract class IRemoteInspectionProvider {
  Future<void> logInspection(String itemId);
  Future<void> bulkScan(List<String> ids);
}