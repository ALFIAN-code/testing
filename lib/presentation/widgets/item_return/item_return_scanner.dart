import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../core/utils/formz.dart';
import '../../bloc/item_return/detail_item_return/detail_item_return_bloc.dart';
import '../state/base_ui_state.dart';


class ItemReturnScanner extends StatefulWidget {
  const ItemReturnScanner({super.key});

  @override
  State<ItemReturnScanner> createState() => _ItemReturnScannerState();
}

class _ItemReturnScannerState extends BaseUiState<ItemReturnScanner> {
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
  Widget build(BuildContext context) => BlocListener<DetailItemReturnBloc, DetailItemReturnState>(
    listenWhen: (DetailItemReturnState previous, DetailItemReturnState current) => previous.scanStatus != current.scanStatus,
    listener: (BuildContext context, DetailItemReturnState state) {
      if (state.scanStatus.isInProgress) {
        showLoading();
      }
      else if (state.scanStatus.isSuccess) {
        hideLoading();
        showSuccessMessage('Barcode ${state.scannedItem ?? "-"} Berhasil di Scan');
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

          context.read<DetailItemReturnBloc>().setScannedItem(
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