import 'package:flutter/material.dart';

class StatusSelector extends StatefulWidget {
  final List<String> statusList;
  final String initialStatus;
  final void Function(String status)? onStatusChanged;
  final bool disabled;

  const StatusSelector({
    super.key,
    required this.statusList,
    this.initialStatus = '',
    this.onStatusChanged,
    this.disabled = false,
  });

  @override
  State<StatusSelector> createState() => _StatusSelectorState();
}

class _StatusSelectorState extends State<StatusSelector> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus.isNotEmpty
        ? widget.initialStatus
        : widget.statusList.first;
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Ubah Status Barang',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 12),

      Wrap(
        spacing: 8,
        children: widget.statusList.map((String status) {
          final bool isSelected = selectedStatus == status;

          return OutlinedButton.icon(
            icon: isSelected
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : const SizedBox(width: 16),
            label: Text(
              status,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor:  isSelected ? Colors.black : Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: widget.disabled ? null : () {
              setState(() {
                selectedStatus = status;
              });
              widget.onStatusChanged?.call(status);
            },
          );
        }).toList(),
      ),
    ],
  );
}
