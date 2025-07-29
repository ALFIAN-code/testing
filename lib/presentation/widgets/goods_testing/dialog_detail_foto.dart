import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../data/models/item/item_maintenance_inspection_image_model.dart';
import '../shared/button/basic_button.dart';
import '../shared/view/full_image_view.dart';
import '../shared/view/image_network_view.dart';

class PhotoDialog extends StatelessWidget {
  final List<ItemMaintenanceInspectionImageModel> imageUrls;

  const PhotoDialog({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text(
                'Lihat Foto Uji',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                imageUrls
                    .map(
                      (ItemMaintenanceInspectionImageModel e) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FullImageView(imagePath: e.imagePath),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageNetworkView(
                            path: e.imagePath,
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: BasicButton(
              variant: ButtonVariant.outlined,
              onClick: () => Navigator.of(context).pop(),
              text: 'Tutup',
            ),
          ),
        ],
      ),
    ),
  );
}
