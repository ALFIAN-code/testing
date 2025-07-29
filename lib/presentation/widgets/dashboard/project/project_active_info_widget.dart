import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/project_active_info_entity.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../shared/dashboard_card_widget.dart';

class ProjectActiveInfoWidget extends StatelessWidget {
  const ProjectActiveInfoWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DashboardBloc, DashboardState>(
        builder: (BuildContext context, DashboardState state) {
          final ProjectActiveInfoEntity? info = state.projectActiveInfo;
          if (info == null) return Container();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DashboardCardWidget(
                  title: 'Total Proyek Aktif',
                  value: info.total,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DashboardCardWidget(
                  title: 'Deadline Proyek',
                  value: info.deadline,
                ),
              ),
            ],
          );
        },
      );
}
