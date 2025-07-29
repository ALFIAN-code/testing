import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app/access_permission/access_permission_bloc.dart';

class AccessWrapper extends StatelessWidget {
  final String module;
  final String action;
  final Widget child;

  const AccessWrapper({
    super.key,
    required this.module,
    required this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final AccessPermissionBloc accessPermission =
        context.watch<AccessPermissionBloc>();

    final bool hasAccess = accessPermission.hasAccess(module, action);

    return Visibility(visible: hasAccess, child: child);
  }
}
