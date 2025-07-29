import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/utils/device_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/item/item_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/item_inspection/item_inspection_bloc.dart';
import '../../widgets/item_inspection/status_badge.dart';
import '../../widgets/shared/alert/basic_alert.dart';
import '../../widgets/shared/alert/sync_status_alert.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/input/text_input.dart';
import '../../widgets/state/base_ui_state.dart';
import '../dashboard/dashboard_page.dart';

@RoutePage()
class ItemInspectionPage extends StatelessWidget {
  const ItemInspectionPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ItemInspectionBloc>(
    create:
        (_) => ItemInspectionBloc(serviceLocator.get(),serviceLocator.get()),
    child: const _ItemInspectionView(),
  );
}

class _ItemInspectionView extends StatefulWidget {
  const _ItemInspectionView({super.key});

  @override
  State<_ItemInspectionView> createState() => _ItemInspectionViewState();
}

class _ItemInspectionViewState extends BaseUiState<_ItemInspectionView> {
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _barcodeController.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<ItemInspectionBloc, ItemInspectionState>(
    listenWhen: (ItemInspectionState previous, ItemInspectionState current) => previous.syncStatus != current.syncStatus,
    listener: (BuildContext context, ItemInspectionState state) {
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
              context.read<ItemInspectionBloc>().syncAll();
            }
          });
        }
      },
        child: BasicScaffold(
          appBar: BasicAppBar(
            title: 'Inspeksi Barang',
            icon: KeenIconConstants.wrenchOutline,
            showBackButton: true,
            onBack: () => context.read<ItemInspectionBloc>().syncAll(),
          ),
          body: BlocListener<ItemInspectionBloc, ItemInspectionState>(
            listenWhen: (ItemInspectionState previous, ItemInspectionState current) => previous.status != current.status,
            listener: (BuildContext context, ItemInspectionState state) {
              if (state.status.isInProgress) {
                showLoading();
              } else if (state.status.isFailure) {
                hideLoading();
                showErrorMessage(state.errorMessage ?? 'Unknown');
              } else if (state.status.isSuccess) {
                hideLoading();
              }
        
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocListener<ItemInspectionBloc, ItemInspectionState>(
                  listener: (BuildContext context, ItemInspectionState state) {},
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const _ScannerView(),
                        const SizedBox(height: 10),
                        BlocBuilder<ItemInspectionBloc, ItemInspectionState>(
                            builder: (BuildContext context, ItemInspectionState state)
                            => SyncStatusAlert(total: state.totalNotSynchronized ?? 0)
                        ),
                        const SizedBox(height: 10),
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
                              context.read<ItemInspectionBloc>().getItemData(_barcodeController.text);
                            }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const _LastInspectionResult(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
              ),
            ),
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
  void dispose() {
    super.dispose();
    controller?.pauseCamera();
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

          context.read<ItemInspectionBloc>().getItemData(
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
      BlocBuilder<ItemInspectionBloc, ItemInspectionState>(
        builder: (BuildContext context, ItemInspectionState state) {
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

                    const TextStyle labelStyle = TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    );

                    const TextStyle valueStyle = TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    );


                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BasicButton(
                          minWidth: MediaQuery.of(context).size.width,
                            text: 'Ubah Data Barang',
                            onClick: () {

                              context.router.push(UpdateItemRoute(id: item.id));
                            }
                        ),
                        const SizedBox(height: 8),
                        const Text('Nama Barang', style: labelStyle),
                        const SizedBox(height: 4),
                        Text(item.itemCode?.name ?? '-', style: valueStyle),

                        const SizedBox(height: 16),
                        const Text('Merek', style: labelStyle),
                        const SizedBox(height: 4),
                        Text(item.brand ?? '-', style: valueStyle),

                        const SizedBox(height: 16),
                        const Text('Tipe / Model', style: labelStyle),
                        const SizedBox(height: 4),
                        Text(item.model ?? '-', style: valueStyle),
                      ],
                    );
                  })
            ],
          );
        },
      );
}
