import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIcon extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode colorBlendMode;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final bool matchTextDirection;
  final Clip clipBehavior;

  const CustomIcon(this.assetName,{
    super.key,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
      'assets/icons/$assetName.svg',
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      matchTextDirection: matchTextDirection,
      clipBehavior: clipBehavior,
      colorFilter: color != null
          ? ColorFilter.mode(color!, colorBlendMode)
          : null,
    );
}
