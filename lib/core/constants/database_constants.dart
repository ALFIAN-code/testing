class DatabaseConstants {
  DatabaseConstants._();
  static const String name = 'regijaya.wms.db';
  static const int version = 1;

  static const String accessPermissionTable = 'access_permissions';
  static const String testResultItemTable = 'test_result_items';
  static const String itemTable = 'items';
  static const String itemCodeTable = 'item_codes';
  static const String itemPreparationScanTable = 'item_preparation_scans';
  static const String onProjectItemScanTable = 'on_project_item_scans';
  static const String prepareReturnItemScanTable = 'prepare_return_item_scans';
  static const String returnItemScanTable = 'return_item_scans';
  static const String conditionTable = 'condition';
  static const String conditionCategoryTable = 'condition_category';
  static const String logInspectionTable = 'log_inspections';
}