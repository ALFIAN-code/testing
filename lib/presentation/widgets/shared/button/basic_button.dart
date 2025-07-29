import 'package:flutter/material.dart';

import '../icon/custom_icon.dart';

enum ButtonVariant { filled, outlined }

class BasicButton extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final EdgeInsets? margin;
  final double? height;
  final double? minWidth;
  final ButtonVariant variant;
  final bool isEnable;
  final String? icon;

  const BasicButton({
    super.key,
    required this.text,
    required this.onClick,
    this.margin,
    this.height,
    this.minWidth,
    this.variant = ButtonVariant.filled,
    this.isEnable = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutlined = variant == ButtonVariant.outlined;
    final Color baseColor = Theme.of(context).primaryColor;
    const Color filledBackground = Color(0xFF1A1C23);
    const Color outlinedBorder = Color(0xFFD1D5DB);
    const Color outlinedText = Color(0xFF4B5675);

    return Container(
      margin: margin,
      child: MaterialButton(
        onPressed: isEnable ? onClick : null,
        minWidth: minWidth,
        height: height ?? 40,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: isOutlined ? Colors.white : filledBackground,
        disabledColor: const Color(0xFFE0EDF6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),

          side:
              isOutlined
                  ? const BorderSide(color: outlinedBorder)
                  : BorderSide.none,
        ),
        child: _content(
          context,
          textColor: isOutlined ? outlinedText : Colors.white,
        ),
      ),
    );
  }

  Widget _content(BuildContext context, {required Color textColor}) {
    if (icon == null) {
      return _text(textColor);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomIcon(icon!,
            color: textColor, width: 18, height: 18,),
        const SizedBox(width: 8),
        _text(textColor),
      ],
    );
  }

  Widget _text(Color textColor) => Text(
    text,
    style: TextStyle(
      fontSize: 14,
      color: textColor,
      fontWeight: FontWeight.w600,
    ),
  );
}
