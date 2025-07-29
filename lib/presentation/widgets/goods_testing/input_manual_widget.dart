import 'package:flutter/material.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../shared/button/basic_button.dart';
import '../shared/input/text_input.dart';

class InputManualWidget extends StatelessWidget {
  const InputManualWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: <Widget>[
        Expanded(
          child: TextInput(
            prefixIcon: KeenIconConstants.scanBarcodeDuoTone,
            controller: controller,
            hintText: 'Masukan Kode',
          ),
        ),
        const SizedBox(width: 12),
        BasicButton(
          onClick: onSubmit,
          text: 'Kirim',
        ),
      ],
    ),
  );
}
