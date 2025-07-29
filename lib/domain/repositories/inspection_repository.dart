abstract class InspectionRepository {
  Future<void> logInspection(String itemId);
  Future<void> sync();
  Future<int> getNotSyncYet();
}