import 'package:flutter/material.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import 'custom_alert.dart';

class SyncStatusAlert extends StatelessWidget {
  final int total;

  const SyncStatusAlert(
      {super.key,
      required this.total});

  @override
  Widget build(BuildContext context) {
    Color alertColor = Colors.green;
    String message = 'Semua data sudah tersinkron';

    if (total != 0) {
      alertColor = Colors.orangeAccent;
      message = '$total belum tersinkron dengan server';
    }

    return CustomAlert(
      icon: KeenIconConstants.wifiDuoTone,
        color: alertColor, message: message);
  }
}
