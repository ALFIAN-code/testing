import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  const DateField({
    super.key,
    required this.label,
    this.initialDate,
    this.onChanged,
    this.required = false,
  });

  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime?>? onChanged;
  final bool required;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      widget.onChanged?.call(picked);
    }
  }

  void _clearDate() {
    setState(() => selectedDate = null);
    widget.onChanged?.call(null);
  }

  String _formattedDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      RichText(
        text: TextSpan(
          text: widget.label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children:
              widget.required
                  ? <InlineSpan>[
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ]
                  : <InlineSpan>[],
        ),
      ),
      const SizedBox(height: 4),

      InkWell(
        onTap: _pickDate,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  selectedDate != null
                      ? _formattedDate(selectedDate)
                      : 'Pilih tanggal',
                  style: TextStyle(
                    color:
                        selectedDate != null
                            ? Colors.black
                            : Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ),
              if (selectedDate != null)
                IconButton(
                  onPressed: _clearDate,
                  icon: Icon(
                    Icons.clear,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  tooltip: 'Hapus tanggal',
                ),
              IconButton(
                onPressed: _pickDate,
                icon: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                tooltip: 'Pilih tanggal',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
