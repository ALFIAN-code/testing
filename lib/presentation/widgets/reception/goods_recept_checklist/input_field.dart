import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({super.key, required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          children: const <InlineSpan>[
            TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value ?? '',
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    ],
  );
}
