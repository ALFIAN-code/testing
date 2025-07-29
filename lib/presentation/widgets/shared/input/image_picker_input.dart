import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_util.dart';
import '../view/full_image_view.dart';
import '../view/image_network_view.dart';

class ImagePickerInput extends StatelessWidget {
  final List<String> imagePaths;
  final int maxImages;
  final void Function(List<String>) onChanged;
  final String? label;

  const ImagePickerInput({
    super.key,
    required this.imagePaths,
    required this.onChanged,
    this.maxImages = 5,
    this.label,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final updatedList = List<String>.from(imagePaths)..add(pickedFile.path);
      onChanged(updatedList.take(maxImages).toList());
    }
  }

  void _removeImage(BuildContext context, int index) {
    final updatedList = List<String>.from(imagePaths)..removeAt(index);
    onChanged(updatedList);
  }

  void _openImageViewer(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullImageView(imagePath: imagePath),
      ),
    );
  }

  bool _isNetworkImage(String path) => !(path.contains('/storage/emulated') || path.startsWith('file://'));

  @override
  Widget build(BuildContext context) {
    final bool canAddMore = imagePaths.length < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? 'Upload Foto',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length + (canAddMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) {
              if (canAddMore && index == 0) {
                return GestureDetector(
                  onTap: () => _pickImage(context),
                  child: Container(
                    width: 128,
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined, size: 24),
                            const SizedBox(width: 4),
                            Text('(${imagePaths.length})', style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('Upload foto', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }

              final int actualIndex = canAddMore ? index - 1 : index;
              final String path = imagePaths[actualIndex];

              final Widget imageWidget = AppUtil.isNetworkImage(path)
                  ? ImageNetworkView(
                path: path,
                width: 72,
                height: 72,
              )
                  : Image.file(
                File(path),
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              );

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => _openImageViewer(context, path),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageWidget,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => _removeImage(context, actualIndex),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(Icons.close, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
