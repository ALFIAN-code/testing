import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../core/utils/formz.dart';
import '../../bloc/item_entrance/detail_item_entrance/detail_item_entrance_bloc.dart';
import '../state/base_ui_state.dart';


class ItemEntranceScanner extends StatefulWidget {
  const ItemEntranceScanner({super.key});

  @override
  State<ItemEntranceScanner> createState() => _ItemEntranceScannerState();
}

class _ItemEntranceScannerState extends BaseUiState<ItemEntranceScanner> {
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
  Widget build(BuildContext context) => BlocListener<DetailItemEntranceBloc, DetailItemEntranceState>(
    listenWhen: (DetailItemEntranceState previous, DetailItemEntranceState current) => previous.scanStatus != current.scanStatus,
    listener: (BuildContext context, DetailItemEntranceState state) {
      if (state.scanStatus.isInProgress) {
        showLoading();
      }
      else if (state.scanStatus.isSuccess) {
        hideLoading();
        showSuccessMessage('Barcode ${state.scannedItem ?? "-"} Berhasil');
      } else if (state.scanStatus.isFailure) {
        hideLoading();
        showErrorMessage(state.errorMessage ?? 'Barcode ${state.scannedItem ?? "-"} Gagal di Scan');
      } else {
        hideLoading();
      }
    },
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: QRView(
          key: qrKey,
          onQRViewCreated:
              (QRViewController controller) =>
              _onQRViewCreated(context, controller),
        ),
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

          context.read<DetailItemEntranceBloc>().setScannedItem(
            scanData.code!,
          );
        }
      } else {
        showErrorMessage('Barcode tidak dapat discan');
      }
    });
  }

  @override
  void dispose() {
    controller?.stopCamera();
    super.dispose();
  }
}