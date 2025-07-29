import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/utils/app/app_status.dart';
import '../../../data/models/base_list_request_model.dart';
import '../../../data/models/item_vendor_reception/item_vendor_reception_item_paginated_model.dart';
import '../../../data/models/item_vendor_reception/item_vendor_reception_model.dart';
import '../../../dependency_injection.dart';
import '../../../domain/repositories/item_vendor_reception_repository.dart';
import '../../bloc/reception/vendor_gooods_reception_detail/vendor_goods_reception_detail_bloc.dart';
import '../../widgets/reception/vendor_goods_reception_detail/info_card_widget.dart';
import '../../widgets/reception/vendor_goods_reception_detail/rejection_card_widget.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/table/basic_table.dart';
import '../../widgets/shared/table/generic_data_table_widget.dart';
import '../../widgets/state/base_ui_state.dart';

@RoutePage()
class VendorGoodsReceptionDetailPage extends StatelessWidget {
  const VendorGoodsReceptionDetailPage({required this.receptionId, super.key});

  final String receptionId;

  @override
  Widget build(BuildContext context) => BlocProvider<VendorGoodsReceptionDetailBloc>(
    create: (_) => VendorGoodsReceptionDetailBloc(serviceLocator.get())..initial(receptionId),
    child: const VendorGoodsReceptionDetailView(),
  );
}

class VendorGoodsReceptionDetailView extends StatefulWidget {
  const VendorGoodsReceptionDetailView({super.key});

  @override
  State<VendorGoodsReceptionDetailView> createState() => _VendorGoodsReceptionDetailViewState();
}

class _VendorGoodsReceptionDetailViewState extends BaseUiState<VendorGoodsReceptionDetailView> {

  final ItemVendorReceptionRepository _itemVendorReceptionRepository = serviceLocator.get();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BasicAppBar(
      icon: KeenIconConstants.officeBagOutline,
      showBackButton: true,
      title: 'Detail Penerimaan Barang Vendor',
    ),
    body: BlocBuilder<VendorGoodsReceptionDetailBloc, VendorGoodsReceptionDetailState>(
      buildWhen: (p,c) => p.status != c.status,
      builder: (BuildContext context, VendorGoodsReceptionDetailState state) {
        if (state.status == AppStatus.loading) {
          showLoading();
        } else {
          hideLoading();
        }

        if (state.status == AppStatus.failure) {
          return Center(
            child: Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.status == AppStatus.success && state.itemVendorReception != null) {
          final ItemVendorReceptionModel reception = state.itemVendorReception!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ReceptionInfoCard(
                  purchaseOrderNumber: reception.poNumber,
                  supplier: reception.supplier?.name ?? '-',
                  estimatedArrival: reception.estimatedDate,
                  submitDate: reception.createdDate,
                ),
                const SizedBox(height: 16),
                if (reception.reasonRejected.isNotEmpty)
                  RejectionReasonCard(
                    reason: reception.reasonRejected,
                  ),
                const SizedBox(height: 16),
                BlocBuilder<VendorGoodsReceptionDetailBloc, VendorGoodsReceptionDetailState>(
                    builder: (BuildContext context, VendorGoodsReceptionDetailState state) {
                      final String? filePath = state.itemVendorReception?.poFilePath;
                      if (filePath == null || filePath.isEmpty) {
                        return Container();
                      }

                      return BasicButton(
                        icon: KeenIconConstants.pdfSolid,
                          text: 'Lihat PDF',
                          onClick: () => context.router.push(PreviewPdfRoute(path: filePath, title: state.itemVendorReception?.poNumber))
                      );
                    }
                ),
                const SizedBox(height: 16),
                PaginatedDataTableWrapper<ItemVendorReceptionItemPaginatedModel>(
                    fetchData: (BaseListRequestModel req, { Map<String, dynamic>? extraParams }) => _itemVendorReceptionRepository.getListItem(reception.id, req),
                  extraParams: <String, dynamic>{
                    'itemVendorId': reception.id,
                  },
                  columns: const <TableColumn>[
                    TableColumn(id: 'index', label: 'No'),
                    TableColumn(id: 'code', label: 'Kode'),
                    TableColumn(id: 'amount', label: 'Jumlah', sortable: true),
                  ],
                  getRow: (ItemVendorReceptionItemPaginatedModel data, int idx) => [
                    DataCell(Text(data.index.toString())),
                    DataCell(Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.itemCode?.name.toString() ?? '-',
                            softWrap: true,
                            style: const TextStyle(fontWeight: FontWeight.w600),),
                          Text(data.itemCode?.code.toString() ?? '-', softWrap: true,),
                          Text(data.itemCode?.coa?.name.toString() ?? '-',softWrap: true)
                        ],
                      ),
                    )),
                    DataCell(Text(data.amount.toString())),
                  ],
                  availableRowsPerPage: const <int>[5, 10, 20],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    ),
  );

}
