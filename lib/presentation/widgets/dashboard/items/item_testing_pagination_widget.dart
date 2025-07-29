import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../../data/models/dashboard/item_test_pagination_model.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../../shared/button/basic_button.dart';
import 'item_test_card_widget.dart';
class ItemTestingPaginationWidget extends StatelessWidget {
  const ItemTestingPaginationWidget({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (DashboardState previous, DashboardState current) =>
          previous.itemTestPaginationModel != current.itemTestPaginationModel,
      builder: (BuildContext context, DashboardState state) {
        final List<ItemTestPaginationModel>? items = state.itemTestPaginationModel?.items;

        if (items == null) {
          // Skeleton/loading indicator
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text('Tidak ada data pengujian barang')),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ...items.take(2).map((ItemTestPaginationModel item) => RepaintBoundary(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ItemTestCard(
                    productCode: item.barcode,
                    itemCode: item.itemCode.code,
                    lastTestDate: item.lastTestedDate,
                    inspections: item.itemInspections,
                    daysAgo: item.nextTestDay,
                  ),
                ),
            )),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: BasicButton(
                variant: ButtonVariant.outlined,
                onClick: () => context.router.push(
                  ItemTestRoute(
                    lastProjectList: state.itemTestPaginationModel!,
                  ),
                ),
                text: 'Lihat Semua ->',
              ),
            ),
          ],
        );
      },
    );
}

