import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? backgroundColor;
  final double backgroundOpacity;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry contentPadding;

  const CustomBadge({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.backgroundOpacity = 0.1,
    this.labelStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? color.withOpacity(backgroundOpacity);

    return Container(
      padding: contentPadding,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: labelStyle ??
            TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: color,
            ),
      ),
    );
  }
}
