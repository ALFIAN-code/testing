import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../../dependency_injection.dart';
import '../../../../domain/repositories/file_repository.dart';

class ImageNetworkView extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  ImageNetworkView({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

   final FileRepository fileRepository = serviceLocator.get();

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
      future: fileRepository.getFile(path),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ??
              const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return errorWidget ??
              const Center(child: Icon(Icons.broken_image));
        }

        final Image image = Image.memory(
          snapshot.data!,
          fit: fit,
          width: width,
          height: height,
        );

        if (borderRadius != null) {
          return ClipRRect(
            child: image,
          );
        }

        return image;
      },
    );
}
