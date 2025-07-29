import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/date_util.dart';
import '../../../core/utils/device_util.dart';
import '../../../data/models/tools_status/tool_status_paginated_model.dart';
import '../../bloc/goods_testing/detail_item_testing/detail_item_testing_bloc.dart';
import '../shared/button/basic_button.dart';

class ConfirmUpdateDialog extends StatelessWidget {
  const ConfirmUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
          padding:  const EdgeInsets.all(20),
        child: BlocBuilder<DetailItemTestingBloc, DetailItemTestingState>(
          builder: (BuildContext context, DetailItemTestingState state) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Simpan Hasil Uji',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 24),
                const Text('Nama - Merk Barang', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text('${state.item.itemCode?.name ?? ''} - ${state.item.itemCode?.itemCodeCategory?.name ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w500)),

                const SizedBox(height: 16),

                const Text('Kategori Barang', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(state.item.itemCode?.itemCodeCategory?.name ?? '-', style: const TextStyle(fontWeight: FontWeight.w500)),

                const SizedBox(height: 16),

                const Text('Barcode Barang', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(state.item.barcode ?? '-', style: const TextStyle(fontWeight: FontWeight.w500)),

                const SizedBox(height: 16),

                const Text('Barcode Barang', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: state.item.itemInspections.map((e) => _buildBadge(e.name)).toList(),
                ),

                const SizedBox(height: 16),

                const Text('Tanggal - Waktu Uji', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(formatReadableDate(state.item.lastTestedDate), style: const TextStyle(fontWeight: FontWeight.w500)),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: BasicButton(
                        onClick: () => Navigator.pop(context),
                        text: 'Batal',
                        variant: ButtonVariant.outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BasicButton(
                        onClick: () {
                          Navigator.pop(context);
                          DeviceUtils.hideKeyboard(context);
                          context.read<DetailItemTestingBloc>().submit();
                        },
                        text: 'Simpan Data',
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ),
      ),
    );

  Widget _buildBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.black87),
    ),
  );

  Widget _buildBadgeStatus(String id, List<ToolStatusPaginatedModel> listTool) {
    return Container();
  }
}
