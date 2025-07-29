import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/dashboard/item_request_unprocessed_model.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../shared/dashboard_card_widget.dart';

class ItemRequestUnprocessedInfoWidget extends StatelessWidget {
  const ItemRequestUnprocessedInfoWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DashboardBloc, DashboardState>(
        builder: (BuildContext context, DashboardState state) {
          final ItemRequestUnprocessedModel? itemRequestUnprocessedModel =
              state.itemRequestUnprocessedModel;

          if (itemRequestUnprocessedModel == null) return Container();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DashboardCardWidget(
                  title: 'Permintaan Barang',
                  value: itemRequestUnprocessedModel.equipment,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DashboardCardWidget(
                  title: 'Habis Pakai',
                  value: itemRequestUnprocessedModel.stock,
                ),
              ),
            ],
          );
        },
      );
}
