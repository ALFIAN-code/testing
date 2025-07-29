import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/utils/app/app_status.dart';
import '../../../data/models/item/item_test_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/goods_testing/goods_testing_cubit.dart';
import '../../widgets/goods_testing/input_manual_widget.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/state/base_ui_state.dart';
import '../dashboard/dashboard_page.dart';

@RoutePage()
class ScanTestingPage extends StatelessWidget {
  const ScanTestingPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<GoodsTestingCubit>(
    create: (_) => GoodsTestingCubit(serviceLocator.get()),
    child: const _HomeCheckContent(),
  );
}

class _HomeCheckContent extends StatefulWidget {
  const _HomeCheckContent();

  @override
  State<_HomeCheckContent> createState() => _HomeCheckContentState();
}

class _HomeCheckContentState extends BaseUiState<_HomeCheckContent> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return BlocListener<GoodsTestingCubit, GoodsTestingState>(
      listener: (BuildContext context, GoodsTestingState state) {
        if (state.status == AppStatus.loading) {
          showLoading();
        } else if (state.status == AppStatus.failure) {
          hideLoading();
          showErrorMessage(state.errorMessage!);
        } else if (state.status == AppStatus.success) {
          hideLoading();
        }
      },
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            const BasicAppBar(
              title: 'Pengujian Barang',
              icon: KeenIconConstants.wrenchOutline,
              showBackButton: true,
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _ScannerView(),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Masukkan Kode Manual',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            InputManualWidget(
              controller: controller,
              onSubmit: () {
                context.read<GoodsTestingCubit>().getLastInspection(
                  controller.text,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
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
      BlocListener<GoodsTestingCubit, GoodsTestingState>(
        listener: (BuildContext context, GoodsTestingState state) {
          if (state.status == AppStatus.success) {
            if (controller != null) {
              controller?.pauseCamera();
            }
            final ItemTestModel? model = state.itemTestModel;
            if (model != null) {
              context.router
                  .push(TestingDetailRoute(itemTestModel: model))
                  .then((_) {
                    controller?.resumeCamera();
                  });
            }
          }
        },
        child: SizedBox(
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
          context.read<GoodsTestingCubit>().getLastInspection(scanData.code!);
        }
      } else {
        showErrorMessage('Barcode tidak dapat discan');
      }
    });
  }
}
