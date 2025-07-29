import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/utils/app_util.dart';
import 'image_network_view.dart';

class FullImageView extends StatelessWidget {
  final String imagePath;

  const FullImageView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget = AppUtil.isNetworkImage(imagePath)
        ? ImageNetworkView(path: imagePath,)
        : Image.file(File(imagePath));

    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Center(child: imageWidget),
      ),
    );
  }
}
