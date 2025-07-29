import 'package:flutter/material.dart';
import '../icon/custom_icon.dart';

class CustomAlert extends StatelessWidget {
  final String message;
  final String? icon;
  final Color color;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? action;
  final String? buttonText;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;

  const CustomAlert({
    super.key,
    required this.message,
    this.icon,
    required this.color,
    this.backgroundColor,
    this.borderColor,
    this.action,
    this.buttonText,
    this.textStyle,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: contentPadding ?? const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: backgroundColor ?? color.withOpacity(0.1),
      border: Border.all(color: borderColor ?? color),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: <Widget>[
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomIcon(
              icon!,
              color: color,
              width: 20,
              height: 20,
            ),
          ),
        Expanded(
          child: Text(
            message,
            style: textStyle ?? TextStyle(color: color),
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: 6),
          action!,
        ]
      ],
    ),
  );
}
