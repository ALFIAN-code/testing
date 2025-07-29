import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/item/item_test_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/goods_testing/detail_item_testing/detail_item_testing_bloc.dart';
import '../../widgets/goods_testing/testing_form_tab.dart';
import '../../widgets/goods_testing/testing_history_tab.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/view/error_retry_view.dart';
import '../../widgets/state/base_ui_state.dart';
import '../dashboard/dashboard_page.dart';

@RoutePage()
class TestingDetailPage extends StatelessWidget {
  final ItemTestModel itemTestModel;
  const TestingDetailPage({super.key, required this.itemTestModel});

  @override
  Widget build(BuildContext context) => BlocProvider<DetailItemTestingBloc>(
    create: (_) => DetailItemTestingBloc(
        itemTestModel, serviceLocator.get(), serviceLocator.get(),
        serviceLocator.get(),serviceLocator.get(), serviceLocator.get())..initial(),
    child: const DefaultTabController(
      length: 2,
      child: _DetailItemTestingView(),
    ),
  );


}

class _DetailItemTestingView extends StatefulWidget {
  const _DetailItemTestingView();

  @override
  State<_DetailItemTestingView> createState() => _DetailItemTestingViewState();
}

class _DetailItemTestingViewState extends BaseUiState<_DetailItemTestingView> {
  @override
  Widget build(BuildContext context) => BlocListener<DetailItemTestingBloc, DetailItemTestingState>(
    listener: (BuildContext context, DetailItemTestingState state) {
      if (state.formStatus.isInProgress) {
        showLoading();
      } else if (state.formStatus.isSuccess) {
        hideLoading();
        showSuccessMessage('Berhasil update data');
        context.router.back();
      } else if (state.formStatus.isFailure) {
        hideLoading();
        showErrorMessage(state.errorMessage ?? '');
      }
    },
    child: BasicScaffold(
        body: Column(
          children: <Widget>[
            const BasicAppBar(
              title: 'Pengujian Barang',
              icon: KeenIconConstants.officeBagOutline,
              showBackButton: true,
              subtitle: 'Terakhir diperbarui 20 menit lalu',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ListView(
                  children: <Widget>[
                    const _ItemInfo(),
                    const SizedBox(height: 24),
              
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: const TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        tabs: <Widget>[
                          Tab(text: 'Pengujian'),
                          Tab(text: 'History Pengujian'),
                        ],
                      ),
                    ),
              
                    BlocBuilder<DetailItemTestingBloc, DetailItemTestingState>(
                      buildWhen: (p,c) => p.status != c.status,
                      builder: (BuildContext context, DetailItemTestingState state) {
              
                        if (state.status.isInProgress) {
                          return const SizedBox(
                              height: 400,
                              child: Center(child: CircularProgressIndicator(),));
                        }
              
                        if (state.status.isFailure) {
                          return ErrorRetryView(
                              errorMessage: state.errorMessage,
                              onRetry: () => context.read<DetailItemTestingBloc>().initial());
                        }
                        return const SizedBox(
                          height: 500,
                          child: TabBarView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: TestingFormTab(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TestingHistoryTab(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
  );
}

class _ItemInfo extends StatelessWidget {
  const _ItemInfo();

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailItemTestingBloc, DetailItemTestingState>(
      builder: (BuildContext context, DetailItemTestingState state) => Column(
          children: <Widget>[
            _buildInfoItem('Nama', state.item.itemCode?.name ?? '-'),
            _buildInfoItem('Merk', state.item.itemCode?.name ?? '-'),
            _buildInfoItem('Barcode', state.item.barcode ?? '-'),
            _buildInfoItem('Kategori', state.item.itemCode?.itemCodeCategory?.name ?? '-'),
            _buildInfoItem('Tanggal Uji', formatReadableDate(state.item.lastTestedDate)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(width: 100, child: Text('Tipe Uji')),
                  const SizedBox(width: 10, child: Text(':')),
                  const SizedBox(width: 10),
                  Wrap(
                    spacing: 8,
                    children: state.item.itemInspections.map((e) => _buildBadge(e.name)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
    );

  Widget _buildInfoItem(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 100, child: Text(label)),
        const SizedBox(width: 10, child: Text(':')),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );

  Widget _buildBadge(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87),
      ),
    );
}
