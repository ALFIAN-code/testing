class EndpointConstants {
  EndpointConstants._();

  static const String mobileToken = 'f374ffbc-7dfc-4ac7-a879-d6865d8dab70';

  static const String userInfo = '/auth/userinfo';
  static const String pageAccess = '/auth/page-access';
  static const String generateCode = '/auth/generate';
  static const String token = '/auth/token';
  static const String logout = '/auth/logout';

  static const String getConfigurationFirebase = '/configuration/get/firebase';

  static const String getConfiguration = '/configuration/get';

  static const String fcmTokenRegister = '/fcm-token/register';
  static const String fcmTokenUnregister = '/fcm-token/unregister';

  static const String getItemStatisticsDashboard = '/dashboard/item-statistic';
  static const String getItemRequestUnprocessedDashboard = '/dashboard/item-request-unprocessed-info';
  static const String projectActiveDashboard = '/dashboard/project-active-pagination';
  static const String projectActiveInfo = '/dashboard/project-active-info';
  static const String itemTestInfo = '/dashboard/item-test-info';
  static const String itemTestPagination = '/dashboard/item-test-pagination';
  static const String itemVendorArrivalPagination = '/dashboard/item-vendor-arrival';

  static const String inspectionLog = '/inspection/log-inspection';
  static const String inspectionBulkLog = '/inspection/bulk-log-inspection';

  static const String itemCodeSyncPagination = '/item-code/sync-pagination';

  static const String itemPagination = '/item/pagination';
  static const String itemUpdateCondition = '/item/update-condition';
  static const String itemDetailById = '/item/get';
  static const String itemUpdate = '/item/update';
  static const String itemDetailBarcode = '/item/get/barcode';
  static const String itemSyncPagination = '/item/sync-pagination';

  static const String itemRequestPagination = '/item-request/pagination';

  static const String itemPreparationPagination = '/item-preparation/pagination';
  static const String itemPreparationSummary = '/item-preparation/project-preparation-summary';
  static const String itemPreparationDetailItem = '/item-preparation/project-preparation-item-detail';
  static const String itemPreparationScanItem = '/item-preparation/scan-item';
  static const String itemPreparationBulkScanItem = '/item-preparation/bulk-scan-item';
  static const String itemPreparationDeleteScannedItem = '/item-preparation/delete-scanned-item';
  static const String itemPreparationStatusCount = '/item-preparation/scan-status-count/project';

  static const String onProjectItemPagination = '/on-project-item/pagination';
  static const String onProjectItemScan = '/on-project-item/scan-to-receive-item';
  static const String onProjectStatusCount = '/on-project-item/scan-status-count/project';
  static const String onProjectRemoveScan = '/on-project-item/remove-scanned-item';
  static const String onProjectItemScannedList = '/on-project-item/scanned-item-list';
  static const String onProjectItemBulkScanItem = '/on-project-item/bulk-scan-to-receive-item';

  static const String prepareReturnItemPagination = '/prepare-return-item/pagination';
  static const String prepareReturnItemScan = '/prepare-return-item/scan-to-receive-item';
  static const String prepareReturnStatusCount = '/prepare-return-item/scan-status-count/project';
  static const String prepareReturnRemoveScan = '/prepare-return-item/remove-scanned-item';
  static const String prepareReturnItemScannedList = '/prepare-return-item/scanned-item-list';
  static const String prepareReturnItemBulkScanItem = '/prepare-return-item/bulk-scan-prepare-return-item';

  static const String itemVendorStatusPagination = '/item-vendor-status/pagination';
  static const String itemVendorConditionPagination = '/item-vendor-condition/pagination';
  static const String itemVendorChecklistPagination = '/item-vendor-checklist/pagination';
  static const String itemVendorReceptionPagination = '/item-vendor-reception/reception/pagination';
  static const String itemVendorReceptionDetail = '/item-vendor-reception/reception/detail/';
  static const String itemVendorReceptionItemPagination = '/item-vendor-reception/reception/pagination/{itemVendorId}/item';
  static const String itemVendorReceptionItemUpdate = '/item-vendor-reception/reception/update';

  static const String itemTestDetail = '/item-test/test/detail/';
  static const String itemTestUpdate = '/item-test/test/update/';
  static const String itemTestGetHistories = '/item-test/get-histories/';

  static const String toolStatusPagination = '/tool-status/pagination';

  static const String conditionPagination = '/condition/pagination';

  static const String conditionCategoryPagination = '/condition-category/pagination';

  static const String uploadFile = '/file/upload-file';
  static const String uploadFileMultiple = '/file/upload-files';
  static const String getFile = '/file/get-file';

  static const String projectItemRequestSummary = '/project/pagination/item-request-summary';

  static const String scanToReturnItem = '/return-item/scan-to-return-item';
  static const String bulkScanToReturnItem = '/return-item/bulk-scan-to-return-item';
}