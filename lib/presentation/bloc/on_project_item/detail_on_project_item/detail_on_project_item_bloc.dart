import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/exceptions/on_project_item_exception.dart';
import '../../../../core/utils/formz.dart';
import '../../../../data/models/item/item_model.dart';
import '../../../../data/models/on_project_item/on_project_item_paginated_model.dart';
import '../../../../data/models/on_project_item/scan_status_count_model.dart';
import '../../../../data/models/on_project_item/scanned_item_list_model.dart';
import '../../../../data/request/on_project_item/get_scanned_item_request.dart';
import '../../../../domain/repositories/item_repository.dart';
import '../../../../domain/repositories/on_project_item_repository.dart';

part 'detail_on_project_item_state.dart';

class DetailOnProjectItemBloc extends Cubit<DetailOnProjectItemState> {

  final ItemRepository _itemRepository;
  final OnProjectItemRepository _onProjectItemRepository;

  DetailOnProjectItemBloc(this._onProjectItemRepository, this._itemRepository) : super(const DetailOnProjectItemState()) {
    _startSyncLoop();
  }

  Timer? _syncTimer;
  Timer? _syncLoadTimer;

  void _startSyncLoop() {
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (state.syncStatus == FormzSubmissionStatus.inProgress) return;
      await _onProjectItemRepository.sync();
      final int total = await _onProjectItemRepository.getNotSyncYet(state.project!.id);
      emit(state.copyWith(totalNotSynchronized: total));
    });

    _syncLoadTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (state.status.isInProgress) return;
      await loadWithoutState();
    });
  }

  Future<void> initial(OnProjectItemPaginatedModel project) async {
    emit(state.copyWith(
        project: project,
      listRequestModel: GetScannedItemListRequest(projectId: project.id)
    ));
    await load();
  }

  void setScannedItem(String? scannedItem) async {
    if (scannedItem == null) throw Exception('Item tidak boleh null');

    emit(state.copyWith(
      scanStatus: FormzSubmissionStatus.inProgress,
    ));
    try {

      final ItemModel? item = await _itemRepository.getDetailBarcodeLocal(scannedItem);

      if (item != null) {
        if (!(item.projectId != null && item.projectId == state.project!.id)) {
          throw Exception('Barang tidak tergabung dalam Project ini');
        }
      } else {
        throw Exception('Data Barang tidak ditemukan');
      }

      final String result = await _onProjectItemRepository.scanItem(state.project!.id, scannedItem);
      final int total = await _onProjectItemRepository.getNotSyncYet(state.project!.id);
      emit(state.copyWith(
        totalNotSynchronized: total,
          scannedItem: scannedItem,
          scannedRequestId: result,
          scanStatus: FormzSubmissionStatus.success));
    } catch(e) {
      emit(state.copyWith(scanStatus: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  void resetScan() async {
    emit(state.copyWith(scanStatus: FormzSubmissionStatus.inProgress));
    try {
      await _onProjectItemRepository.cancelRequest(state.scannedRequestId ?? '');
      final int total = await _onProjectItemRepository.getNotSyncYet(state.project!.id);
      emit(state.copyWith(
        totalNotSynchronized: total,
          resetScannedItem: true,
          resetScannedRequestId: true,
          scanStatus: FormzSubmissionStatus.success));
    } on NoDatLocalOnProjectItemException catch(e) {
      emit(state.copyWith(
          resetScannedItem: true,
          scanStatus: FormzSubmissionStatus.failure,
          errorMessage: e.message),);
    }
    catch(e) {
      emit(state.copyWith(
          scanStatus: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> load() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final GetScannedItemListRequest? request = state.listRequestModel;
      final OnProjectItemPaginatedModel? project = state.project;

      if (request == null || project == null) {
        throw Exception('Project atau request tidak boleh null');
      }

      final List<Object> results = await Future.wait([
        _onProjectItemRepository.getScanStatusCount(project.id),
        _onProjectItemRepository.getScannedList(request),
      ]);

      final ScanStatusCountModel scanStatusCount = results[0] as ScanStatusCountModel;
      final List<ScannedItemListModel> listScannedItem = results[1] as List<ScannedItemListModel>;

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        scanStatusCount: scanStatusCount,
        listScanned: listScannedItem,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadWithoutState() async {

    final GetScannedItemListRequest? request = state.listRequestModel;
    final OnProjectItemPaginatedModel? project = state.project;

    if (request == null || project == null) {
      throw Exception('Project atau request tidak boleh null');
    }

    final List<Object> results = await Future.wait([
      _onProjectItemRepository.getScanStatusCount(project.id),
      _onProjectItemRepository.getScannedList(request),
    ]);

    final ScanStatusCountModel scanStatusCount = results[0] as ScanStatusCountModel;
    final List<ScannedItemListModel> listScannedItem = results[1] as List<ScannedItemListModel>;

    emit(state.copyWith(
      scanStatusCount: scanStatusCount,
      listScanned: listScannedItem,
    ));
  }


  void setSearch(String? search) async {
    final GetScannedItemListRequest? currentRequest = state.listRequestModel;

    if (currentRequest == null) return;

    final GetScannedItemListRequest updatedRequest = currentRequest.copyWith(search: search ?? '');

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final List<Object> results = await Future.wait([
        _onProjectItemRepository.getScannedList(updatedRequest),
      ]);

      final List<ScannedItemListModel> listScannedItem = results[0] as List<ScannedItemListModel>;

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        listScanned: listScannedItem,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void setScanFilter(bool isScanned) async {
    final GetScannedItemListRequest? currentRequest = state.listRequestModel;

    if (currentRequest == null) return;

    if (currentRequest.isScanned == isScanned) return;

    final GetScannedItemListRequest updatedRequest = currentRequest.copyWith(isScanned: isScanned);

    emit(state.copyWith(
      listRequestModel: updatedRequest,
        status: FormzSubmissionStatus.inProgress));

    try {
      final List<Object> results = await Future.wait(<Future<Object>>[
        _onProjectItemRepository.getScannedList(updatedRequest),
      ]);

      final List<ScannedItemListModel> listScannedItem = results[0] as List<ScannedItemListModel>;

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        listScanned: listScannedItem,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void deleteScan(String requestId) async {
    emit(state.copyWith(deleteStatus: FormzSubmissionStatus.inProgress));
    try {
      await _onProjectItemRepository.deleteRequest(requestId);
      emit(state.copyWith(deleteStatus: FormzSubmissionStatus.success));
      await load();
    } catch(e) {
      emit(state.copyWith(
        deleteStatus: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void syncAll() async {
    if (state.syncStatus.isInProgress) return;
    emit(state.copyWith(syncStatus: FormzSubmissionStatus.inProgress));
    try {
      await _onProjectItemRepository.sync();
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