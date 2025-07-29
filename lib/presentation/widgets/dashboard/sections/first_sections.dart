import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../../core/utils/formz.dart';
import '../../../../data/models/dashboard/item_vendor_arrival_model.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../../shared/button/basic_button.dart';
import '../../shared/view/error_retry_view.dart';
import '../items/item_request_unprocessed_info_widget.dart';
import '../items/item_statistics_widget.dart';
import '../items/item_vendor_arrival_card.dart';


class FirstSectionWidget extends StatelessWidget {
  const FirstSectionWidget({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<DashboardBloc, DashboardState>(
    buildWhen: (DashboardState previous, DashboardState current) => previous.statusFirstSection != current.statusFirstSection ,
    builder: (BuildContext context, DashboardState state) {
      if (state.statusFirstSection.isInProgress) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (state.statusFirstSection.isFailure) {
        return ErrorRetryView(
          errorMessage: state.errorMessage,
          onRetry: () => context.read<DashboardBloc>().load(),
        );
      } else if (state.statusFirstSection.isSuccess) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Pemantauan Barang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ItemRequestUnprocessedInfoWidget(),
            const SizedBox(height: 10),
            const Text(
              'Statistik Barang',
              style: TextStyle(fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ItemStatisticsWidget(),
            const SizedBox(height: 10),
            const Text(
              'Monitoring Barang Vendor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            BlocBuilder<DashboardBloc, DashboardState>(
                buildWhen: (DashboardState previous, DashboardState current) => previous.itemVendorArrivalModel != current.itemVendorArrivalModel,
                builder: (BuildContext context, DashboardState state) {
                  final List<ItemVendorArrivalModel>? items = state.itemVendorArrivalModel?.items;
                  if (items != null && items.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ...items.take(2).map((ItemVendorArrivalModel item) => RepaintBoundary(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ItemVendorArrivalCard(model: item),
                          ),
                        )),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: BasicButton(
                            variant: ButtonVariant.outlined,
                            onClick: () => context.router.push(
                              ItemVendorArrivalRoute(
                                list: state.itemVendorArrivalModel!,
                              ),
                            ),
                            text: 'Lihat Semua ->',
                          ),
                        ),
                      ],
                    );
                  }

                  return Container();
                }
            ),

          ],
        );
      }
      return Container();
    },
  );
}