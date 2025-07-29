import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../../core/utils/app_util.dart';
import '../../../../core/utils/formz.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../../shared/dialog/pick_role_dialog.dart';

class UserInformationWidget extends StatelessWidget {
  const UserInformationWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DashboardBloc, DashboardState>(
        builder:
            (BuildContext context, DashboardState state) => GestureDetector(
              onTap:
                  () => showDialog(
                    context: context,
                    builder:
                        (ctx) => PickRoleDialog(
                          onResult: (FormzSubmissionStatus action) {
                            if (action.isSuccess) {
                              ctx.router.pushAndPopUntil(
                                const SplashRoute(),
                                predicate: (route) => false,
                              );
                            } else {
                              Navigator.pop(ctx);
                            }
                          },
                        ),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.name ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        AppUtil.toPascalCase(
                          (state.role ?? '').replaceAll('-', ' '),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8BC34A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_drop_down_outlined,
                        color: Color(0xFF8BC34A),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      );
}
