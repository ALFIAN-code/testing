import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/on_project_item/on_project_item_paginated_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/on_project_item/detail_on_project_item/detail_on_project_item_bloc.dart';
import '../../widgets/on_project_item/on_project_item_scanner.dart';
import '../../widgets/on_project_item/scanned_item_table.dart';
import '../../widgets/shared/alert/custom_alert.dart';
import '../../widgets/shared/alert/sync_status_alert.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/metronic_button.dart';
import '../../widgets/shared/card/basic_card.dart';
import '../../widgets/shared/dialog/confirm_dialog.dart';
import '../../widgets/shared/icon/custom_icon.dart';
import '../../widgets/shared/input/choice_chip_input.dart';
import '../../widgets/state/base_ui_state.dart';

@RoutePage()
class DetailOnProjectItemPage extends StatelessWidget {
  final OnProjectItemPaginatedModel project;
  const DetailOnProjectItemPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) => BlocProvider<DetailOnProjectItemBloc>(
      create: (_) => DetailOnProjectItemBloc(serviceLocator.get(), serviceLocator.get())..initial(project),
      child: const _DetailOnProjectItemPageView(),
    );
}

class _DetailOnProjectItemPageView extends StatefulWidget {
  const _DetailOnProjectItemPageView();

  @override
  State<_DetailOnProjectItemPageView> createState() => _DetailOnProjectItemPageViewState();
}

class _DetailOnProjectItemPageViewState extends BaseUiState<_DetailOnProjectItemPageView> {

  @override
  Widget build(BuildContext context) => BlocListener<DetailOnProjectItemBloc, DetailOnProjectItemState>(
    listenWhen: (DetailOnProjectItemState previous, DetailOnProjectItemState current) => previous.syncStatus != current.syncStatus,
    listener: (BuildContext context, DetailOnProjectItemState state) {
      if (state.syncStatus.isInProgress) {
        showLoading();
      } else if (state.syncStatus.isSuccess || state.syncStatus.isFailure){
        hideLoading();
        context.router.pop();
      }
    },
    child: PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<DetailOnProjectItemBloc>().syncAll();
            }
          });
        }
      },
      child: Scaffold(
        appBar: BasicAppBar(
          title: 'Detail Penerimaan',
          icon: KeenIconConstants.tabletBookOutline,
          showBackButton: true,
          onBack: () => context.read<DetailOnProjectItemBloc>().syncAll(),
        ),
        body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BasicCard(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  backgroundColor: Colors.grey.shade50,
                  child: BlocBuilder<DetailOnProjectItemBloc, DetailOnProjectItemState>(
                    builder: (BuildContext context, DetailOnProjectItemState state) => Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildProjectCardItem(
                            title: 'Nama Proyek',
                            content: state.project?.name ?? '-',
                            icon: KeenIconConstants.calendarCodeDuoTone,
                          ),
                        ),
                        const SizedBox(width: 4,),
                        Expanded(
                          child: _buildProjectCardItem(
                            title: 'Tanggal Persiapan',
                            content: formatReadableDate(state.project?.createdDate),
                            icon: KeenIconConstants.calendar2DuoTone,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const OnProjectItemScanner(),
                const SizedBox(height: 16),
                BlocBuilder<DetailOnProjectItemBloc, DetailOnProjectItemState>(
                    builder: (BuildContext context, DetailOnProjectItemState state)
                    => SyncStatusAlert(total: state.totalNotSynchronized ?? 0)
                ),
                const SizedBox(height: 16),
                const _TotalItemResult(),
                const SizedBox(height: 16),
                const _ScanStatusAlert(),
                const SizedBox(height: 16),
                BlocBuilder<DetailOnProjectItemBloc, DetailOnProjectItemState>(
                  buildWhen: (DetailOnProjectItemState previous, DetailOnProjectItemState current) => previous.listRequestModel?.isScanned != current.listRequestModel?.isScanned,
                  builder: (BuildContext context,DetailOnProjectItemState state) => CustomChipInput<bool>(
                        chipsPerRow: 2,
                        maxHeight: 200,
                        items: const <bool>[true, false],
                        labelBuilder: (bool item) => item ? 'Sudah Scan' : 'Belum Scan',
                        selectedTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white
                        ),
                      unselectedTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black
                      ),
                        valueBuilder: (bool item) => item,
                        selectedValue: state.listRequestModel?.isScanned ?? true,
                        onSelected: (bool selectedItem, dynamic selectedValue) {
                          context.read<DetailOnProjectItemBloc>().setScanFilter(selectedItem);
                        }
                    ),
                ),
                const SizedBox(height: 16),
                const ScannedItemTable()
              ],
            )
          )
        ),
      ),
    ),
  );

  Widget _buildProjectCardItem({
    required String title,
    required String content,
    required String icon,
  }) => Row(
    children: <Widget>[
      CustomIcon(icon, color: Colors.grey, width: 22, height: 22),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // atau fade, clip
              softWrap: false,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _TotalItemResult extends StatelessWidget {
  const _TotalItemResult();

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailOnProjectItemBloc, DetailOnProjectItemState>(
    buildWhen: (DetailOnProjectItemState previous, DetailOnProjectItemState current) => previous.status != current.status,
    builder: (BuildContext context, DetailOnProjectItemState state) => Row(
      children: <Widget>[
        Expanded(
          child: _buildTextInputWithLabel('Jumlah Permintaan',state.scanStatusCount?.shippedCount ?? 0),
        ),
        const SizedBox(width: 10),
        Expanded(child: _buildTextInputWithLabel('Barang Sudah Di Scan', state.scanStatusCount?.receivedCount ?? 0)),
      ],
    ),
  );

  Widget _buildTextInputWithLabel(String title, int value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      const SizedBox(height: 6),
      BasicCard(
          backgroundColor: Colors.grey.shade100,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(value.toString())))
    ],
  );
}

class _ScanStatusAlert extends StatelessWidget {
  const _ScanStatusAlert();

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailOnProjectItemBloc, DetailOnProjectItemState>(
    builder: (BuildContext context, DetailOnProjectItemState state) {
      String icon = '';
      Color colorAlert = Colors.white;
      String message = '';

      if (state.scanStatus.isSuccess) {
        icon = KeenIconConstants.shieldTickDuoTone;
        message = "Barcode ${state.scannedItem ?? "-"} Berhasil di Scan";
        colorAlert = Colors.green;

      } else if (state.scanStatus.isFailure) {
        icon = KeenIconConstants.shieldCrossDuoTone;
        colorAlert = Colors.red;
        message = "Barcode ${state.scannedItem ?? "-"} Gagal di Scan";
      }

      if ((state.scanStatus.isSuccess || state.scanStatus.isFailure) && state.scannedItem != null) {
        return CustomAlert(
          color: colorAlert,
          icon: icon,
          message: message,
          action: state.scanStatus.isSuccess ? MetronicButton(
            color: Colors.redAccent,
            text: 'Batal',
            onPressed: () {
              showDialog<void>(
                  context: context,
                  builder: (BuildContext ctx) => ConfirmDialog(
                        title: 'Batal Scan',
                        content: 'Anda yakin ingin membatalkan scan?',
                        onConfirm: () {
                          Navigator.pop(ctx);
                          context.read<DetailOnProjectItemBloc>().resetScan();
                        },
                        onCancel: () => Navigator.pop(ctx)
                    ));
            },) : null,
        );
      } else {
        return const SizedBox.shrink();
      }
    },
  );
}


