import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/utils/device_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/condition/condition_paginated_model.dart';
import '../../../data/models/condition_category/condition_category_paginated_model.dart';
import '../../../data/models/item/item_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/item_status/change_item_status/change_item_status_bloc.dart';
import '../../widgets/item_inspection/status_badge.dart';
import '../../widgets/shared/alert/basic_alert.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/input/choice_chip_input.dart';
import '../../widgets/shared/input/text_input.dart';
import '../../widgets/state/base_ui_state.dart';
import '../dashboard/dashboard_page.dart';
import '../goods_testing/testing_detail_page.dart';

@RoutePage()
class ChangeItemStatusPage extends StatelessWidget {
  const ChangeItemStatusPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ChangeItemStatusBloc>(
    create:
        (_) => ChangeItemStatusBloc(
          serviceLocator.get(),
          serviceLocator.get(),
          serviceLocator.get(),
          serviceLocator.get()
        )..initial(),
    child: const _ChangeItemStatusView(),
  );
}

class _ChangeItemStatusView extends StatefulWidget {
  const _ChangeItemStatusView({super.key});

  @override
  State<_ChangeItemStatusView> createState() => _ChangeItemStatusViewState();
}

class _ChangeItemStatusViewState extends BaseUiState<_ChangeItemStatusView> {
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _barcodeController.dispose();
  }


  @override
  Widget build(BuildContext context) => BasicScaffold(
    appBar: const BasicAppBar(
      title: 'Ubah Status Barang',
      icon: KeenIconConstants.wrenchOutline,
      showBackButton: true,
    ),
    body: BlocListener<ChangeItemStatusBloc, ChangeItemStatusState>(
      listener: (BuildContext context, ChangeItemStatusState state) {
        if (state.status.isInProgress) {
          showLoading();
        } else if (state.status.isFailure) {
          hideLoading();
          showErrorMessage(state.errorMessage ?? 'Unknown');
        } else if (state.status.isSuccess) {
          hideLoading();
        }
  
        if (state.submitStatus.isInProgress) {
          showLoading();
        } else if (state.submitStatus.isFailure) {
          hideLoading();
          showErrorMessage(state.errorMessage ?? 'Unknown');
        } else if (state.submitStatus.isSuccess) {
          hideLoading();
          if (state.itemTestModel != null) {
            context.router.push(TestingDetailRoute(itemTestModel: state.itemTestModel!));
          } else {
            showSuccessMessage('Berhasil mengubah status barang');
            context.read<ChangeItemStatusBloc>().initial();
          }
        }
  
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocListener<ChangeItemStatusBloc, ChangeItemStatusState>(
            listener: (BuildContext context, ChangeItemStatusState state) {},
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const _ScannerView(),
                  const SizedBox(height: 20),
                  _buildOrDivider(),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextInput(
                          controller: _barcodeController,
                          hintText: 'Masukan Kode',
                          prefixIcon: KeenIconConstants.scanBarcodeDuoTone,
                        ),
                      ),
                      const SizedBox(width: 10),
                      BasicButton(text: 'Kirim', onClick: () {
                        DeviceUtils.hideKeyboard(context);
                        context.read<ChangeItemStatusBloc>().getItemData(_barcodeController.text);
                      }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _LastInspectionResult()
                ],
              ),
            )
        ),
      ),
    ),
  );

  Widget _buildOrDivider() => Row(
    children: <Widget>[
      Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text('atau', style: TextStyle(color: Colors.grey)),
      ),
      Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
    ],
  );
}

class _ScannerView extends StatefulWidget {
  const _ScannerView();

  @override
  State<_ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends BaseUiState<_ScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'barcode_scanner');
  Barcode? result;
  QRViewController? controller;
  String? lastScannedCode;
  DateTime? lastScanTime;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) =>
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: QRView(
            key: qrKey,
            onQRViewCreated:
                (QRViewController controller) =>
                _onQRViewCreated(context, controller),
          ),
        ),
      );

  void _onQRViewCreated(BuildContext ctx, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((Barcode scanData) {
      final DateTime now = DateTime.now();
      if (scanData.code != null) {
        if (lastScanTime == null ||
            now.difference(lastScanTime!) > const Duration(seconds: 3)) {

          lastScannedCode = scanData.code;
          lastScanTime = now;

          context.read<ChangeItemStatusBloc>().getItemData(
            scanData.code!,
          );
        }
      } else {
        showErrorMessage('Barcode tidak dapat discan');
      }
    });
  }
}

class _LastInspectionResult extends StatelessWidget {
  const _LastInspectionResult();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChangeItemStatusBloc, ChangeItemStatusState>(
        builder: (BuildContext context, ChangeItemStatusState state) {
          if (state.status.isInitial ||
              state.status.isInProgress) {
            return Container();
          }

          return Column(
            children: <Widget>[
              Builder(
                  builder: (BuildContext context) {

                    if ((state.scannedBarcode ?? '').isEmpty) {
                      return const SizedBox.shrink();
                    }

                    if (state.itemModel != null) {
                      return BasicAlert(
                        type: BasicAlertType.success,
                        message: 'Berhasil ${state.scannedBarcode ?? '-'} ditemukan',
                      );
                    } else {
                      return BasicAlert(
                        type: BasicAlertType.danger,
                        message: 'Barcode ${state.scannedBarcode ??
                            '-'} tidak berhasil ditemukan',
                      );
                    }
                  }),
              const SizedBox(height: 10),
              Builder(
                  builder: (BuildContext context) {
                    final ItemModel? item = state.itemModel;
                    if (item == null) {
                      return Container();
                    }

                    StatusType type = StatusType.info;

                    switch(item.condition?.conditionCategory?.code) {
                      case 'digunakan':
                        type = StatusType.info;
                        break;
                      case 'usulan-hapus':
                        type = StatusType.warning;
                        break;
                      case 'tidak-digunakan':
                        type = StatusType.danger;
                      default:
                        type = StatusType.disabled;
                        break;
                    }

                    return Column(
                      children: [
                        const Text('Kondisi Saat Ini'),
                        const SizedBox(height: 10),
                        StatusBadge(
                            label: '${item.condition?.conditionCategory?.name ?? '-'} - ${item.condition?.name ?? '-'}',
                            type: type
                        ),
                      ],
                    );
                  }),
              const SizedBox(height: 10),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 20),
              Builder(
                  builder: (BuildContext context) {
                    final ItemModel? item = state.itemModel;
                    if (item == null) {
                      return Container();
                    }

                    if (item.itemInspections.isNotEmpty) {
                      return _buildTestInfo(context);
                    } else {
                      return _buildConditionInput(context, state);
                    }
                  })
            ],
          );
        },
      );

  Widget _buildTestInfo(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tidak Data Mengubah Status karena perubahan status barang harus lewat modul pengujian.'),
        const SizedBox(height: 20),
        BasicButton(
          minWidth: MediaQuery.of(context).size.width,
            text: 'Masuk ke Modul Pengujian',
            onClick: () => context.read<ChangeItemStatusBloc>().submit(true)
        ),
        const SizedBox(height: 20),
        Divider(color: Colors.grey.shade300, thickness: 1),
      ],
    );

  Widget _buildConditionInput(BuildContext context, ChangeItemStatusState state) => Column(
      children: [
        ChoiceChipInput<ConditionCategoryPaginatedModel>(
            choices: state.conditionCategories,
            labelBuilder: (ConditionCategoryPaginatedModel item) => item.name,
            valueBuilder: (ConditionCategoryPaginatedModel item) => item.id,
            selectedValue: state.selectedConditionCategoryId,
            onSelected: (ConditionCategoryPaginatedModel selectedItem, dynamic selectedValue) {
              context.read<ChangeItemStatusBloc>().updateSelectedConditionCategory(selectedItem.id);
            }
        ),
        const Divider(),
        Builder(
          builder: (BuildContext context) {
            if (state.selectedConditionCategoryId == null || state.selectedConditionCategoryId == '') {
              return Container();
            } else {
              List<ConditionPaginatedModel> conditions = state.conditions;
              conditions = conditions.where((ConditionPaginatedModel e) => e.conditionCategoryId == state.selectedConditionCategoryId).toList();
              return ChoiceChipInput<ConditionPaginatedModel>(
                  choices: conditions,
                  chipsPerRow: 3,
                  labelBuilder: (ConditionPaginatedModel item) => item.name,
                  valueBuilder: (ConditionPaginatedModel item) => item.id,
                  selectedValue: state.selectedConditionId,
                  onSelected: (ConditionPaginatedModel selectedItem, dynamic selectedValue) {
                    context.read<ChangeItemStatusBloc>().submit(false, conditionId: selectedItem.id);
                  }
              );
            }

          },
        ),
      ],
    );
}
