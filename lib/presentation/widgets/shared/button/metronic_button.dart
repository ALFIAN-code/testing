import 'package:flutter/material.dart';
import '../icon/custom_icon.dart';

class MetronicButton extends StatelessWidget {
  final String? text;
  final String? icon;
  final VoidCallback onPressed;
  final Color color;
  final bool isEnabled;
  final EdgeInsets? margin;
  final double? height;
  final double? minWidth;

  const MetronicButton({
    super.key,
    required this.color,
    this.text,
    this.icon,
    required this.onPressed,
    this.isEnabled = true,
    this.margin,
    this.height,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    final Color background = color.withValues(alpha: 0.2);
    final Color border = color;
    final Color textColor = color;

    return Container(
      margin: margin,
      child: MaterialButton(
        onPressed: isEnabled ? onPressed : null,
        minWidth: minWidth,
        height: height ?? 40,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: background,
        disabledColor: const Color(0xFFE0EDF6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: border),
        ),
        child: _buildContent(textColor ?? color),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (icon != null && text != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomIcon(icon!, color: textColor, width: 18, height: 18),
          const SizedBox(width: 8),
          _buildText(textColor),
        ],
      );
    } else if (icon != null) {
      return CustomIcon(icon!, color: textColor, width: 18, height: 18);
    } else {
      return _buildText(textColor);
    }
  }

  Widget _buildText(Color textColor) => Text(
    text ?? '',
    style: TextStyle(
      fontSize: 14,
      color: textColor,
      fontWeight: FontWeight.w600,
    ),
  );

  Color darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }
}
