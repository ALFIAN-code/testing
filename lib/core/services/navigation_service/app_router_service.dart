import 'package:auto_route/auto_route.dart';

import '../../../presentation/widgets/dashboard/items/item_vendor_arrival_card.dart';
import 'app_router_service.gr.dart';
import 'auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: DashboardRoute.page, guards: <AutoRouteGuard>[AuthGuard()]),
    AutoRoute(page: ListItemRoute.page, guards: <AutoRouteGuard>[AuthGuard()]),
    AutoRoute(
      page: ListPreparationRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: DetailPreparationRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: ItemInspectionRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: VendorGoodsReceptionRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: VendorGoodsReceptionDetailRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: GoodsChecklistFormRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: PreviewPdfRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: ScanTestingRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: TestingDetailRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: ChangeItemStatusRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: UpdateItemRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: ListItemReturnRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: ListItemEntranceRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: DetailItemEntranceRoute.page,
      maintainState: false,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: ActiveProjectRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(page: ItemTestRoute.page, guards: <AutoRouteGuard>[AuthGuard()]),
    AutoRoute(
      page: ListOnProjectItemRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: DetailOnProjectItemRoute.page,
      maintainState: false,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: DetailItemReturnRoute.page,
      maintainState: false,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: ListPrepareReturnItemRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: DetailPrepareReturnItemRoute.page,
      maintainState: false,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: ItemVendorArrivalRoute.page,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
  ];
}
