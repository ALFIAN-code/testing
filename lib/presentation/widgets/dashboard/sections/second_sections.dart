import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../../core/utils/formz.dart';
import '../../../../data/models/dashboard/item_vendor_arrival_model.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../../shared/button/basic_button.dart';
import '../../shared/view/error_retry_view.dart';
import '../items/item_vendor_arrival_card.dart';
import '../project/project_active_info_widget.dart';
import '../items/item_test_info_widget.dart';
import '../items/item_testing_pagination_widget.dart';
import '../project/project_monitoring_widget.dart';

class SecondSectionWidget extends StatelessWidget {
  const SecondSectionWidget({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<DashboardBloc, DashboardState>(
    buildWhen: (DashboardState previous, DashboardState current) => previous.statusSecondSection != current.statusSecondSection ,
    builder: (BuildContext context, DashboardState state) {
      if (state.statusSecondSection.isInProgress) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (state.statusSecondSection.isFailure) {
        return ErrorRetryView(
          errorMessage: state.errorMessage,
          onRetry: () => context.read<DashboardBloc>().load(),
        );
      } else if (state.statusSecondSection.isSuccess) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Pemantauan Proyek',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ProjectActiveInfoWidget(),
            const SizedBox(height: 10),
            const Text(
              'Data Monitoring Proyek',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ProjectMonitoringWidget(),
            const SizedBox(height: 10),
            const Text(
              'Pemantauan Pengujian Baring',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ItemTestInfoWidget(),
            const SizedBox(height: 10),
            const Text(
              'Data Barang Perlu Uji Segera',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ItemTestingPaginationWidget(),
            SizedBox(height: 10),
          ],
        );
      }

      return Container();
    },
  );
}