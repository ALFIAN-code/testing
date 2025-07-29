import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../data/models/item_vendor_reception/item_vendor_reception_paginated_model.dart';
import '../../../../domain/entities/vendor_goods_reception_entity.dart';

class VendorGoodsReceptionCard extends StatelessWidget {
  final ItemVendorReceptionPaginatedModel reception;
  final VoidCallback? onDetailTap;
  final VoidCallback? onCheckTap;

  const VendorGoodsReceptionCard({
    super.key,
    required this.reception,
    this.onDetailTap,
    this.onCheckTap,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildHeader(),
        const SizedBox(height: 12),
        _buildPurchaseOrderInfo(),
        const SizedBox(height: 16),
        _buildStatusRow(),
        const SizedBox(height: 16),
        _buildActionButtons(),
      ],
    ),
  );

  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        reception.code,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: regiJayaPrimaryContainerBackground,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: regiJayaPrimaryBorder),
        ),
        child: Text(
          '${reception.totalItem} Barang',
          style: const TextStyle(
            fontSize: 12,
            color: regiJayaSecondaryText,
          ),
        ),
      ),
    ],
  );

  Widget _buildPurchaseOrderInfo() => Row(
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              reception.supplier?.name ?? '-',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              '${_formatDate(DateTime.parse(reception.estimatedDate))} - ${reception.estimatedTime}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text(
                  'No. PO : ${reception.poNumber}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(width: 16),

              ],
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildStatusRow() => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: _buildStatusChip(
            'Status',
            reception.itemVendorStatus?.name ?? '-',
            _getStatusColor(reception.itemVendorStatus?.code),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatusChip(
            'Kondisi',
            reception.itemVendorCondition?.name ?? '-',
            _getVerificationColor(reception.itemVendorCondition?.code),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatusChip(
            'Tgl Submit',
            _formatDate(reception.createdDate),
            Colors.white,
          ),
        ),
      ],
    ),
  );


  Widget _buildStatusChip(String label, String value, Color color) =>
      DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(6),
        color: const Color.fromRGBO(219, 223, 233, 1),
        strokeWidth: 2,
        dashPattern: const <double>[8, 4],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: regiJayaPrimaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: regiJayaSecondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildActionButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      _buildActionButton(
        label: 'Detail',
        icon: Icons.remove_red_eye_outlined,
        backgroundColor: regiJayaPrimary,
        textColor: Colors.white,
        onTap: onDetailTap,
      ),
      const SizedBox(width: 12),
      Builder(
          builder: (BuildContext context) {
            bool isVisible = false;
            bool isCheckAgain = false;
            if ((reception.itemVendorCondition?.code ?? '') == 'not-yet-checked') {
              isVisible = true;
            } else if ((reception.itemVendorCondition?.code ?? '') != 'not-yet-checked') {
              if ((reception.itemVendorStatus?.code ?? '') == 'revised') {
                isVisible = true;
                isCheckAgain = true;
              }
            }

            if (!isVisible) return Container();

            return _buildActionButton(
              label: !isCheckAgain ? 'Periksa' : 'Periksa Ulang',
              icon: Icons.check_circle_outline,
              backgroundColor: Colors.white,
              textColor: regiJayaPrimaryText,
              borderColor: regiJayaPrimaryBorder,
              onTap: onCheckTap,
            );
          }
      )
    ],
  );

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    VoidCallback? onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'approval':
      case 'submitted':
        return Colors.white;
      case 'report':
      case 'revised':
        return Colors.orange;
      case 'done':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getVerificationColor(String? verification) {
    switch (verification) {
      case 'not-yet-checked':
        return Colors.white;
      case 'not-suitable':
        return Colors.red;
      case 'suitable':
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  String _formatDate(DateTime date) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
