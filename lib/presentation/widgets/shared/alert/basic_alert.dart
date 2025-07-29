import 'package:flutter/material.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import '../icon/custom_icon.dart';

enum BasicAlertType { success, info, warning, danger }

class BasicAlert extends StatelessWidget {
  final BasicAlertType type;
  final String message;
  final String? buttonText;

  const BasicAlert({
    super.key,
    required this.type,
    required this.message,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = getAlertStyle(type);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data['background'] as Color,
        border: Border.all(color: data['border'] as Color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomIcon(
            data['icon'] as String,
            color: data['iconColor'] as Color,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: data['textColor'] as Color),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, dynamic> getAlertStyle(BasicAlertType type) {
  switch (type) {
    case BasicAlertType.success:
      return <String, dynamic>{
        'background': Colors.green[50],
        'border': Colors.green,
        'icon': KeenIconConstants.shieldTickDuoTone,
        'iconBackground': Colors.green[100],
        'iconColor': Colors.green,
        'textColor': Colors.green[800],
      };
    case BasicAlertType.info:
      return <String, dynamic>{
        'background': Colors.blue[50],
        'border': Colors.blue,
        'icon': KeenIconConstants.shieldTickDuoTone,
        'iconBackground': Colors.blue[100],
        'iconColor': Colors.blue,
        'textColor': Colors.blue[800],
      };
    case BasicAlertType.warning:
      return <String, dynamic>{
        'background': Colors.orange[50],
        'border': Colors.orange,
        'icon': KeenIconConstants.shieldSlashDuoTone,
        'iconBackground': Colors.orange[100],
        'iconColor': Colors.orange,
        'textColor': Colors.orange[800],
      };
    case BasicAlertType.danger:
      return <String, dynamic>{
        'background': Colors.red[50],
        'border': Colors.red,
        'icon': KeenIconConstants.shieldCrossDuoTone,
        'iconBackground': Colors.red[100],
        'iconColor': Colors.red,
        'textColor': Colors.red[800],
      };
  }
}
