import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/base_list_request_model.dart';
import '../../../data/models/item_request/item_request_paginated_model.dart';
import '../../../data/models/project/project_item_request_summary_pagination_model.dart';
import '../../../dependency_injection.dart';
import '../../../domain/repositories/item_request_repository.dart';
import '../../bloc/item_entrance/detail_item_entrance/detail_item_entrance_bloc.dart';
import '../../widgets/item_entrance/item_entrance_scanner.dart';
import '../../widgets/item_entrance/project_item_table.dart';
import '../../widgets/shared/alert/custom_alert.dart';
import '../../widgets/shared/alert/sync_status_alert.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/metronic_button.dart';
import '../../widgets/shared/card/basic_card.dart';
import '../../widgets/shared/dialog/confirm_dialog.dart';
import '../../widgets/shared/dropdown/searchable_dropdown.dart';
import '../../widgets/shared/icon/custom_icon.dart';
import '../../widgets/shared/repetitive_caller_widget.dart';
import '../../widgets/state/base_ui_state.dart';

@RoutePage()
class DetailItemEntrancePage extends StatelessWidget {
  final ProjectItemRequestSummaryPaginatedModel project;
  const DetailItemEntrancePage({super.key, required this.project});


  @override
  Widget build(BuildContext context) => BlocProvider<DetailItemEntranceBloc>(
      create: (_) => DetailItemEntranceBloc(serviceLocator.get())..initial(project),
    child: const _DetailItemEntranceContent(),
  );
}

class _DetailItemEntranceContent extends StatefulWidget {
  const _DetailItemEntranceContent();

  @override
  State<_DetailItemEntranceContent> createState() => _DetailItemEntranceContentState();
}

class _DetailItemEntranceContentState extends BaseUiState<_DetailItemEntranceContent> {

  late ItemRequestRepository _itemRequestRepository;

  @override
  void initState() {
    super.initState();
    _itemRequestRepository = serviceLocator.get();
  }

  @override
  Widget build(BuildContext context) =>BlocListener<DetailItemEntranceBloc, DetailItemEntranceState>(
    listenWhen: (DetailItemEntranceState previous, DetailItemEntranceState current) => previous.syncStatus != current.syncStatus,
    listener: (BuildContext context, DetailItemEntranceState state) {
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
              context.read<DetailItemEntranceBloc>().syncAll();
            }
          });
        }
      },
      child: Scaffold(
        appBar: const BasicAppBar(
          title: 'Detail Persiapan Barang Proyek',
          icon: KeenIconConstants.tabletBookOutline,
          showBackButton: true,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BasicCard(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    backgroundColor: Colors.grey.shade50,
                    child: BlocBuilder<DetailItemEntranceBloc, DetailItemEntranceState>(
                      builder: (BuildContext context, DetailItemEntranceState state) => Row(
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
                  const ItemEntranceScanner(),
                  const SizedBox(height: 16),
                  BlocBuilder<DetailItemEntranceBloc, DetailItemEntranceState>(
                    buildWhen: (DetailItemEntranceState previous, DetailItemEntranceState current) => previous.totalNotSynchronized != current.totalNotSynchronized,
                      builder: (BuildContext context, DetailItemEntranceState state)
                      => SyncStatusAlert(total: state.totalNotSynchronized ?? 0)
                  ),
                  const SizedBox(height: 16),
                  const _TotalItemResult(),
                  const SizedBox(height: 16),
                  const _ScanStatusAlert(),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (BuildContext context) {
                      final String projectId = context.select((DetailItemEntranceBloc bloc) => bloc.state.project?.id ?? '');
                      return SearchableDropdown<ItemRequestPaginatedModel>(
                        dataLoader: () =>  _itemRequestRepository.getListByProject(
                            projectId,
                            BaseListRequestModel.initial(pageSize: 100)),
                        itemBuilder:
                            (ItemRequestPaginatedModel item) => SearchableDropdownItem(
                          value: item.id,
                          label: item.code,
                          widget: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Text(item.code),
                          ),
                        ),
                        defaultValue: '',
                        canClear: true,
                        onChange: (String? value, String? label) {
                          context.read<DetailItemEntranceBloc>().setItemRequestId(value);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16,),
                  const ProjectItemTable()
                ],
              )
            ),
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
  Widget build(BuildContext context) => BlocBuilder<DetailItemEntranceBloc, DetailItemEntranceState>(
    buildWhen: (DetailItemEntranceState previous, DetailItemEntranceState current) => previous.scanStatusCount != current.scanStatusCount,
    builder: (BuildContext context, DetailItemEntranceState state) => Row(
        children: <Widget>[
          Expanded(
            child: _buildTextInputWithLabel('Barang Disetujui',state.scanStatusCount?.approvedCount ?? 0),
          ),
          const SizedBox(width: 10),
          Expanded(child: _buildTextInputWithLabel('Sudah Scan', state.scanStatusCount?.preparedCount ?? 0)),
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
  const _ScanStatusAlert({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailItemEntranceBloc, DetailItemEntranceState>(
      builder: (BuildContext context, DetailItemEntranceState state) {
        String icon = '';
        Color colorAlert = Colors.white;
        String message = '';

        if (state.scanStatus.isSuccess) {
          icon = KeenIconConstants.shieldTickDuoTone;
          message = "Barcode ${state.scannedItem ?? "-"} Berhasil";
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
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) => ConfirmDialog(
                          title: 'Batal Scan',
                          content: 'Anda yakin ingin membatalkan scan?',
                          onConfirm: () {
                            Navigator.pop(ctx);
                            context.read<DetailItemEntranceBloc>().resetScan();
                          },
                          onCancel: () => Navigator.pop(ctx),
                      ),);
                },) : null,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
}

