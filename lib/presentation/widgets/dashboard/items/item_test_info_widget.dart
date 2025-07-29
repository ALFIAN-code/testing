import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/dashboard/item_test_info_model.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../shared/dashboard_card_widget.dart';

class ItemTestInfoWidget extends StatelessWidget {
  const ItemTestInfoWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DashboardBloc, DashboardState>(
        bloc: context.read<DashboardBloc>(),
        builder: (BuildContext context, DashboardState state) {
          final ItemTestInfoModel? itemTestInfoModel = state.itemTestInfoModel;

          if (itemTestInfoModel == null) return Container();

          return Row(
            children: [
              Expanded(
                child: DashboardCardWidget(
                  title: 'Total barang',
                  value: itemTestInfoModel.total,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DashboardCardWidget(
                  title: 'Hari ini',
                  value: itemTestInfoModel.today,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DashboardCardWidget(
                  title: 'Terlambat',
                  value: itemTestInfoModel.late,
                ),
              ),
            ],
          );
        },
      );
}
