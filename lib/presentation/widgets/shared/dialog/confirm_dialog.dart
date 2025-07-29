import 'package:flutter/material.dart';

import '../button/basic_button.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
      content: Text(content),
      actions: [
        BasicButton(
          onClick: onCancel,
          text: 'Batal',
          variant: ButtonVariant.outlined,
        ),
        BasicButton(
          onClick: onConfirm,
          text: 'OK',
        ),
      ],
    );
}
