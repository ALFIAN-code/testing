import 'package:flutter/material.dart';

class RadioNoteFieldWidget extends StatelessWidget {
  final String title;
  final bool groupValue;
  final ValueChanged<bool?> onChanged;
  final String firstRadioValue;
  final String secondRadioValue;
  final bool showNoteField;

  const RadioNoteFieldWidget({
    super.key,
    required this.title,
    required this.groupValue,
    required this.onChanged,
    required this.firstRadioValue,
    required this.secondRadioValue,
    this.showNoteField = false,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Container(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(width: 3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '1. $title',
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              children: <Widget>[
                Radio<bool>(
                  value: true,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                ),
                Text(firstRadioValue),
                const SizedBox(width: 16),
                Radio<bool>(
                  value: false,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                ),
                Text(secondRadioValue),
              ],
            ),
            if (showNoteField) ...<Widget>[
              const SizedBox(height: 12),
              const Row(
                children: <Widget>[
                  Icon(Icons.note, color: Colors.black, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Catatan (isi strip - jika tidak ada)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}
