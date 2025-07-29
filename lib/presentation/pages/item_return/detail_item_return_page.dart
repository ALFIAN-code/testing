import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/device_util.dart';
import '../../../core/utils/formz.dart';
import '../../../dependency_injection.dart';
import '../../bloc/item_return/detail_item_return/detail_item_return_bloc.dart';
import '../../widgets/item_return/item_return_scanner.dart';
import '../../widgets/shared/alert/custom_alert.dart';
import '../../widgets/shared/alert/sync_status_alert.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/button/metronic_button.dart';
import '../../widgets/shared/dialog/confirm_dialog.dart';
import '../../widgets/shared/input/text_input.dart';
import '../../widgets/state/base_ui_state.dart';
import '../dashboard/dashboard_page.dart';

@RoutePage()
class DetailItemReturnPage extends StatelessWidget {
  const DetailItemReturnPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<DetailItemReturnBloc>(
      create: (_) => DetailItemReturnBloc(serviceLocator.get()),
    child:const _DetailItemReturnView(),
  );
}

class _DetailItemReturnView extends StatefulWidget {
  const _DetailItemReturnView();

  @override
  State<_DetailItemReturnView> createState() => _DetailItemReturnViewState();
}

class _DetailItemReturnViewState extends BaseUiState<_DetailItemReturnView> {

  late TextEditingController _barcodeController;

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController();
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<DetailItemReturnBloc, DetailItemReturnState>(
    listenWhen: (DetailItemReturnState previous, DetailItemReturnState current) => previous.syncStatus != current.syncStatus,
    listener: (BuildContext context, DetailItemReturnState state) {
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
              context.read<DetailItemReturnBloc>().syncAll();
            }
          });
        }
      },
      child: BasicScaffold(
        appBar: BasicAppBar(
          title: 'Barang Masuk dari Proyek',
          icon: KeenIconConstants.folderDownDuoTone,
          showBackButton: true,
          onBack: () => context.read<DetailItemReturnBloc>().syncAll(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: SingleChildScrollView(
          child: Column(
            children: [
              const ItemReturnScanner(),
              const SizedBox(height: 8),
              BlocBuilder<DetailItemReturnBloc, DetailItemReturnState>(
                  builder: (BuildContext context, DetailItemReturnState state)
                  => SyncStatusAlert(total: state.totalNotSynchronized ?? 0)
              ),
              const SizedBox(height: 8),
              _buildOrDivider(),
              const SizedBox(height: 8),
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
                    context.read<DetailItemReturnBloc>().setScannedItem(_barcodeController.text);
                  }),
                ],
              ),
              const SizedBox(height: 16),
              const _ScanStatusAlert(),
            ],
          ),),
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


class _ScanStatusAlert extends StatelessWidget {
  const _ScanStatusAlert();

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailItemReturnBloc, DetailItemReturnState>(
    builder: (BuildContext context, DetailItemReturnState state) {
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
              showDialog(
                context: context,
                builder: (BuildContext ctx) => ConfirmDialog(
                  title: 'Batal Scan',
                  content: 'Anda yakin ingin membatalkan scan?',
                  onConfirm: () {
                    Navigator.pop(ctx);
                    context.read<DetailItemReturnBloc>().resetScan();
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
