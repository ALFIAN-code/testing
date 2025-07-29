import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/item_preparation/item_preparation_count_model.dart';
import '../../../../data/models/item_preparation/item_preparation_detail_model.dart';
import '../../../../data/models/item_preparation/item_preparation_summary_model.dart';
import '../../../../data/models/on_project_item/scan_status_count_model.dart';
import '../../../../data/models/project/project_item_request_summary_pagination_model.dart';
import '../../../../data/request/item_preparation/item_preparation_summary_request.dart';
import '../../../../domain/repositories/item_preparation_repository.dart';

part 'detail_item_entrance_state.dart';

class DetailItemEntranceBloc extends Cubit<DetailItemEntranceState> {

  final ItemPreparationRepository _itemPreparationRepository;

  DetailItemEntranceBloc(this._itemPreparationRepository) : super(const DetailItemEntranceState()) {
    _startSyncLoop();
  }

  Timer? _syncTimer;
  Timer? _syncLoadTimer;

  void _startSyncLoop() {
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (state.syncStatus == FormzSubmissionStatus.inProgress) return;
      await _itemPreparationRepository.sync();
      final int total = await _itemPreparationRepository.getNotSyncYet(state.project!.id);
      emit(state.copyWith(totalNotSynchronized: total));
    });

    _syncLoadTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (state.status.isInProgress) return;
      await getNotSyncYet();
    });
  }


  Future<void> initial(ProjectItemRequestSummaryPaginatedModel project) async {
    emit(state.copyWith(
      project: project,
    ),);
    await load();
  }

  void setScannedItem(String? scannedItem) async {
    emit(state.copyWith(
      scanStatus: FormzSubmissionStatus.inProgress,
    ));
    try {
      final String result = await _itemPreparationRepository.scanItem(state.project!.id, scannedItem!);
      final int total = await _itemPreparationRepository.getNotSyncYet(state.project!.id);
      emit(state.copyWith(
        totalNotSynchronized: total,
        scannedItem: scannedItem,
          scannedRequestId: result,
          scanStatus: FormzSubmissionStatus.success));
    } catch(e) {

      emit(state.copyWith(
          scanStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString()));
    }
  }

  void resetScan() async {
    emit(state.copyWith(scanStatus: FormzSubmissionStatus.inProgress));
    try {
      await _itemPreparationRepository.cancelRequest(state.scannedRequestId ?? '');
      final int total = await _itemPreparationRepository.getNotSyncYet(state.project!.id);

      emit(state.copyWith(
          totalNotSynchronized: total,
          resetScannedItem: true,
          resetScannedRequestId: true,
          scanStatus: FormzSubmissionStatus.success));
    } catch(e) {
      emit(state.copyWith(
        resetScannedItem: true,
          scanStatus: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  void setItemRequestId(String? itemRequestId) async {
    emit(state.copyWith(
        resetItemRequestId: itemRequestId == null,
        itemRequestId: itemRequestId,
        status: FormzSubmissionStatus.inProgress));

    try {
      final ItemPreparationSummaryRequest request = ItemPreparationSummaryRequest(
        projectId: state.project!.id,
        search: state.search ?? '',
        itemRequestId: state.itemRequestId,
      );
      final List<ItemPreparationSummaryModel> results = await _itemPreparationRepository.getSummary(request);
      emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          items: results));
    } catch(e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  void setSearch(String? search) async {
    emit(state.copyWith(
      search: search,
        status: FormzSubmissionStatus.inProgress));

    try {
      final ItemPreparationSummaryRequest request = ItemPreparationSummaryRequest(
        projectId: state.project!.id,
        search: state.search ?? '',
        itemRequestId: state.itemRequestId,
      );
      final List<ItemPreparationSummaryModel> results = await _itemPreparationRepository.getSummary(request);
      emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          items: results));
    } catch(e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> getNotSyncYet() async {
    try {
      final String projectId = state.project?.id ?? '';
      final ItemPreparationCountModel scanStatusCount = await _itemPreparationRepository.getScanStatusCount(projectId);

      emit(state.copyWith(
        scanStatusCount: scanStatusCount,));
    } catch(e) {
      rethrow;
    }
  }

  Future<void> load() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final ItemPreparationSummaryRequest request = ItemPreparationSummaryRequest(
        projectId: state.project!.id,
        search: state.search ?? '',
        itemRequestId: state.itemRequestId,
      );
      final List<Object> results = await Future.wait([
        _itemPreparationRepository.getScanStatusCount(request.projectId),
        _itemPreparationRepository.getSummary(request),
        _itemPreparationRepository.getNotSyncYet(request.projectId)
      ]);
      emit(state.copyWith(
          totalNotSynchronized: results[2] as int,
          scanStatusCount: results[0] as ItemPreparationCountModel,
          status: FormzSubmissionStatus.success,
          items: results[1] as List<ItemPreparationSummaryModel>));
    } catch(e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> loadDetail(String itemCodeId) async {
    emit(state.copyWith(detailStatus: FormzSubmissionStatus.inProgress));
    try {
      final List<ItemPreparationDetailModel> result = await _itemPreparationRepository.getDetailItem(
        state.project!.id,
        itemCodeId,
      );
      emit(state.copyWith(detailStatus: FormzSubmissionStatus.success, detailItems: result));
    } catch(e) {
      emit(state.copyWith(detailStatus: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> delete(String itemCodeId, String requestId) async {
    emit(state.copyWith(deleteStatus: FormzSubmissionStatus.inProgress));
    try {
      await _itemPreparationRepository.deleteRequest(requestId);
      emit(state.copyWith(deleteStatus: FormzSubmissionStatus.success));
      await loadDetail(itemCodeId);
    } catch(e) {
      emit(state.copyWith(deleteStatus: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  void syncAll() async {
    if (state.syncStatus.isInProgress) return;
    emit(state.copyWith(syncStatus: FormzSubmissionStatus.inProgress));
    try {
      await _itemPreparationRepository.sync();
      emit(state.copyWith(syncStatus: FormzSubmissionStatus.success));
    } catch(e) {
      emit(state.copyWith(
        syncStatus: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }


  @override
  Future<void> close() {
    _syncTimer?.cancel();
    _syncLoadTimer?.cancel();
    return super.close();
  }

}