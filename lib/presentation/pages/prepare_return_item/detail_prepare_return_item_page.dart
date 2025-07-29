import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/prepare_return_item/prepare_return_item_paginated_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/prepare_return_item/detail_prepare_return_item/detail_prepare_return_item_bloc.dart';
import '../../widgets/prepare_return_item/prepare_return_item_scanner.dart';
import '../../widgets/prepare_return_item/scanned_item_table.dart';
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
class DetailPrepareReturnItemPage extends StatelessWidget {
  final PrepareReturnItemPaginatedModel project;
  const DetailPrepareReturnItemPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) => BlocProvider<DetailPrepareReturnItemBloc>(
    create: (_) => DetailPrepareReturnItemBloc(serviceLocator.get(), serviceLocator.get())..initial(project),
    child: const _DetailPrepareReturnItemPageView(),
  );
}

class _DetailPrepareReturnItemPageView extends StatefulWidget {
  const _DetailPrepareReturnItemPageView();

  @override
  State<_DetailPrepareReturnItemPageView> createState() => _DetailPrepareReturnItemPageViewState();
}

class _DetailPrepareReturnItemPageViewState extends BaseUiState<_DetailPrepareReturnItemPageView> {

  @override
  Widget build(BuildContext context) => BlocListener<DetailPrepareReturnItemBloc, DetailPrepareReturnItemState>(
    listenWhen: (DetailPrepareReturnItemState previous, DetailPrepareReturnItemState current) => previous.syncStatus != current.syncStatus,
    listener: (BuildContext context, DetailPrepareReturnItemState state) {
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
              context.read<DetailPrepareReturnItemBloc>().syncAll();
            }
          });
        }
      },
      child: Scaffold(
        appBar: BasicAppBar(
          title: 'Detail Persiapan Pengembalian',
          icon: KeenIconConstants.tabletBookOutline,
          showBackButton: true,
          onBack: () => context.read<DetailPrepareReturnItemBloc>().syncAll(),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    BasicCard(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      backgroundColor: Colors.grey.shade50,
                      child: BlocBuilder<DetailPrepareReturnItemBloc, DetailPrepareReturnItemState>(
                        builder: (BuildContext context, DetailPrepareReturnItemState state) => Row(
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
                    const PrepareReturnItemScanner(),
                    const SizedBox(height: 16),
                    BlocBuilder<DetailPrepareReturnItemBloc, DetailPrepareReturnItemState>(
                        builder: (BuildContext context, DetailPrepareReturnItemState state)
                        => SyncStatusAlert(total: state.totalNotSynchronized ?? 0)
                    ),
                    const SizedBox(height: 16),
                    const _TotalItemResult(),
                    const SizedBox(height: 16),
                    const _ScanStatusAlert(),
                    const SizedBox(height: 16),
                    BlocBuilder<DetailPrepareReturnItemBloc, DetailPrepareReturnItemState>(
                      buildWhen: (DetailPrepareReturnItemState previous, DetailPrepareReturnItemState current) => previous.listRequestModel?.isScanned != current.listRequestModel?.isScanned,
                      builder: (BuildContext context,DetailPrepareReturnItemState state) => CustomChipInput<bool>(
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
                            context.read<DetailPrepareReturnItemBloc>().setScanFilter(selectedItem);
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
  Widget build(BuildContext context) => BlocBuilder<DetailPrepareReturnItemBloc, DetailPrepareReturnItemState>(
    buildWhen: (DetailPrepareReturnItemState previous, DetailPrepareReturnItemState current) => previous.status != current.status,
    builder: (BuildContext context, DetailPrepareReturnItemState state) => Row(
      children: <Widget>[
        Expanded(
          child: _buildTextInputWithLabel('Barang Proyek',state.scanStatusCount?.onProjectItemCount ?? 0),
        ),
        const SizedBox(width: 10),
        Expanded(child: _buildTextInputWithLabel('Barang Dikirim', state.scanStatusCount?.returningItemCount ?? 0)),
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
  Widget build(BuildContext context) => BlocBuilder<DetailPrepareReturnItemBloc, DetailPrepareReturnItemState>(
    builder: (BuildContext context, DetailPrepareReturnItemState state) {
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
                        context.read<DetailPrepareReturnItemBloc>().resetScan();
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


