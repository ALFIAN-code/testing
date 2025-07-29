import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../bloc/preparation/detail_preparation/detail_preparation_bloc.dart';
import '../../state/base_ui_state.dart';

class ItemPreparationScanner extends StatefulWidget {
  const ItemPreparationScanner({super.key});

  @override
  State<ItemPreparationScanner> createState() => _ItemPreparationScannerState();
}

class _ItemPreparationScannerState extends BaseUiState<ItemPreparationScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'barcode_scanner');
  Barcode? result;
  QRViewController? controller;

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
  Widget build(BuildContext context) => SizedBox(
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
  );

  void _onQRViewCreated(BuildContext ctx, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((Barcode scanData) {
      if (scanData.code != null) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //ctx.read<DetailPreparationBloc>().scanItem(scanData.code ?? '');
          });
        }
      } else {
        showErrorMessage('Barcode tidak dapat discan');
      }
    });
  }

  @override
  void dispose() async {
    await controller?.stopCamera();
    super.dispose();
  }
}