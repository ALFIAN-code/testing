import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/app/app_status.dart';
import '../../../data/models/pagination_model.dart';
import '../../../data/models/pagination_response_model.dart';
import '../../../data/models/user/user_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/preparation/detail_preparation/detail_preparation_bloc.dart';
import '../../widgets/preparation/detail/item_preparation_scanner.dart';
import '../../widgets/preparation/detail/item_status_table.dart';
import '../../widgets/shared/alert/basic_alert.dart';
import '../../widgets/shared/alert/custom_alert.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/metronic_button.dart';
import '../../widgets/shared/card/basic_card.dart';
import '../../widgets/shared/dropdown/searchable_dropdown.dart';
import '../../widgets/shared/icon/custom_icon.dart';
import '../../widgets/state/base_ui_state.dart';

@RoutePage()
class DetailPreparationPage extends StatelessWidget {
  const DetailPreparationPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<DetailPreparationBloc>(
    create: (_) => DetailPreparationBloc(
      serviceLocator.get(),serviceLocator.get(),
    ),
    child: const Scaffold(
      appBar: BasicAppBar(
        title: 'Persiapan Barang',
        icon: KeenIconConstants.tabletBookOutline,
        showBackButton: true,
      ),
      body: _DetailPreparationContent(),
    ),
  );
}

class _DetailPreparationContent extends StatefulWidget {
  const _DetailPreparationContent();

  @override
  State<_DetailPreparationContent> createState() => _DetailPreparationContentState();
}

class _DetailPreparationContentState extends BaseUiState<_DetailPreparationContent> {
  @override
  Widget build(BuildContext context) => BlocListener<DetailPreparationBloc, DetailPreparationState>(
      listener: (BuildContext context, DetailPreparationState state) {

        if (state.status == AppStatus.loading || state.scanStatus == AppStatus.loading) {
          showLoading();
        }

        if (state.status != AppStatus.loading && state.scanStatus != AppStatus.loading) {
          hideLoading();
        }

        if (state.status == AppStatus.failure || state.scanStatus == AppStatus.failure) {
          showErrorMessage(state.errorMessage ?? "Error");
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Column(
            children: <Widget>[
              BasicCard(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                backgroundColor: Colors.grey.shade50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildProjectCardItem(
                        title: 'Nama Proyek',
                        content: 'Proyek',
                        icon: KeenIconConstants.calendarCodeDuoTone,
                      ),
                    ),
                    Expanded(
                      child: _buildProjectCardItem(
                        title: 'Tanggal Persiapan',
                        content: '20 Mei 2025',
                        icon: KeenIconConstants.calendar2DuoTone,
                      ),
                    ),
                  ],
                ),
              ),
              const _SynchronizeStatusAlert(),
              const ItemPreparationScanner(),
              const SizedBox(height: 14),
              const _TotalItemResult(),
              const SizedBox(height: 10),
              const _ScannedResultAlert(),
              const SizedBox(height: 16),
              SearchableDropdown<UserModel>(
                dataLoader: loadUsers,
                itemBuilder:
                    (UserModel user) => SearchableDropdownItem(
                  value: user.id,
                  label: user.name,
                  widget: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Text(user.name),
                  ),
                ),
                defaultValue: '1',
                isMandatory: true,
                onChange: (String? value, String? label) {},
              ),
              const SizedBox(height: 16),
              const ItemStatusTable(),
              const SizedBox(height: 20),
            ],
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
      Column(
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
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  );

  Future<PaginationResponseModel<UserModel>> loadUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return PaginationResponseModel(
        items: [], pagination: PaginationModel(currentPage: 1, pageSize: 1,totalItems: 1,totalPages: 1));
  }
}


class _TotalItemResult extends StatelessWidget {
  const _TotalItemResult();

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailPreparationBloc, DetailPreparationState>(

    builder: (BuildContext context, DetailPreparationState state) {
      final int acceptedItem =  0;
      final int scannedItem = 0;

      return Row(
        children: <Widget>[
          Expanded(
            child: _buildTextInputWithLabel('Jumlah Barang Disetujui',acceptedItem),
          ),
          const SizedBox(width: 10),
          Expanded(child: _buildTextInputWithLabel('Barang Sudah Di Scan', scannedItem)),
        ],
      );
    },
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

class _ScannedResultAlert extends StatelessWidget {
  const _ScannedResultAlert();

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailPreparationBloc, DetailPreparationState>(
      buildWhen: (DetailPreparationState previous, DetailPreparationState current) =>
      previous.scanStatus != current.scanStatus,
      builder: (BuildContext context, DetailPreparationState state) {
        String icon = '';
        Color colorAlert = Colors.white;
        String message = '';

        if (state.scanStatus == AppStatus.success) {
          icon = KeenIconConstants.shieldTickDuoTone;
          message = "Barcode ${state.scannedItem ?? "-"} Berhasil di Scan";
          colorAlert = Colors.green;

          Future.microtask(() async {
            await Future.delayed(const Duration(seconds: 3));
            //context.read<DetailPreparationBloc>().resetScanStatus();
          });

        } else if (state.scanStatus == AppStatus.failure) {
          icon = KeenIconConstants.shieldCrossDuoTone;
          colorAlert = Colors.red;
          message = "Barcode ${state.scannedItem ?? "-"} Gagal di Scan";

          Future.microtask(() async {
            await Future.delayed(const Duration(seconds: 3));
            //context.read<DetailPreparationBloc>().resetScanStatus();
          });
        }

        if (state.scanStatus == AppStatus.success ||
            state.scanStatus == AppStatus.failure) {
          return CustomAlert(
            color: colorAlert,
            icon: icon,
            message: message,
            action: MetronicButton(
                color: Colors.redAccent,
                text: 'Batal',
                onPressed: () {
                  //context.read<DetailPreparationBloc>().resetScanStatus();
                }),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
}

class _SynchronizeStatusAlert extends StatelessWidget {
  const _SynchronizeStatusAlert({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailPreparationBloc, DetailPreparationState>(
        builder: (BuildContext context, DetailPreparationState state) {
          if (false) {
            // Color colorAlert = Colors.white;
            // String message = '';
            //
            // if (state.currentItem!.itemServerTotal == state.currentItem!.itemScannedTotal) {
            //   colorAlert = Colors.green;
            //   message = 'Seluruh barang berhasil disinkronkan ke server.';
            // } else {
            //   colorAlert = Colors.amber;
            //   message = '${(state.currentItem!.itemScannedTotal - state.currentItem!.itemServerTotal)} dari ${state.currentItem!.itemServerTotal} barang belum disinkronkan ke server.';
            // }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CustomAlert(
                  color: Colors.black,
                  icon: KeenIconConstants.wifiDuoTone,
                  message: '',
                ),
              );
          }

          return Container();
        });
}

