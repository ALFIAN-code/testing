import 'package:flutter/material.dart';

enum StatusType { info, disabled, warning, danger, success }

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> style = _getStyle(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style['background'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: style['border']!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(radius: 4, backgroundColor: style['dot']),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: style['text'], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getStyle(StatusType type) {
    switch (type) {
      case StatusType.info:
        return <String, Color>{
          'background': const Color(0xFFE6F0FF),
          'border': const Color(0xFF3399FF),
          'dot': const Color(0xFF3399FF),
          'text': const Color(0xFF3399FF),
        };
      case StatusType.disabled:
        return <String, Color>{
          'background': const Color(0xFFF2F3F5),
          'border': const Color(0xFFB0B3B8),
          'dot': const Color(0xFFB0B3B8),
          'text': const Color(0xFF606770),
        };
      case StatusType.danger:
        return <String, Color>{
          'background': const Color(0xFFFFE6E6),
          'border': const Color(0xFFFF4D4F),
          'dot': const Color(0xFFFF4D4F),
          'text': const Color(0xFFFF4D4F),
        };
      case StatusType.warning:
        return <String, Color>{
          'background': const Color(0xFFFFFAE6),
          'border': const Color(0xFFFFD700),
          'dot': const Color(0xFFFFA500),
          'text': const Color(0xFFFFA500),
        };
      case StatusType.success:
        return <String, Color>{
          'background': const Color(0xFFE6FFED),
          'border': const Color(0xFF28A745),
          'dot': const Color(0xFF28A745),
          'text': const Color(0xFF28A745),
        };
    }
  }
}
