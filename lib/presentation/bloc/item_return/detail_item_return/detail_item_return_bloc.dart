import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/formz.dart';
import '../../../../domain/repositories/return_item_repository.dart';

part 'detail_item_return_state.dart';

class DetailItemReturnBloc extends Cubit<DetailItemReturnState> {

  final ReturnItemRepository _returnItemRepository;

  DetailItemReturnBloc(this._returnItemRepository) : super(const DetailItemReturnState()) {
    _startSyncLoop();
  }

  Timer? _syncTimer;

  void _startSyncLoop() {
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (state.syncStatus == FormzSubmissionStatus.inProgress) return;
      await _returnItemRepository.sync();
      final int total = await _returnItemRepository.getNotSyncYet();
      emit(state.copyWith(totalNotSynchronized: total));
    });
  }

  void setScannedItem(String? scannedItem) async {
    if (scannedItem == null) throw Exception('Item tidak boleh null');
    emit(state.copyWith(
      scanStatus: FormzSubmissionStatus.inProgress,
    ));
    try {
      final String result = await _returnItemRepository.scanItem(scannedItem);
      final int total = await _returnItemRepository.getNotSyncYet();
      emit(state.copyWith(
          totalNotSynchronized: total,
          scannedItem: scannedItem,
          scannedRequestId: result,
          scanStatus: FormzSubmissionStatus.success));
    } catch(e) {
      emit(state.copyWith(scanStatus: FormzSubmissionStatus.failure, errorMessage: e.toString()));
      rethrow;
    }
  }

  void resetScan() async {
    emit(state.copyWith(scanStatus: FormzSubmissionStatus.inProgress));
    try {
      await _returnItemRepository.cancelRequest(state.scannedRequestId ?? '');
      final int total = await _returnItemRepository.getNotSyncYet();
      emit(state.copyWith(
          totalNotSynchronized: total,
          resetScannedItem: true,
          resetScannedRequestId: true,
          scanStatus: FormzSubmissionStatus.success));
    } catch(e) {
      emit(state.copyWith(scanStatus: FormzSubmissionStatus.failure,
          resetScannedItem: true,
          errorMessage: e.toString()));
    }
  }

  void syncAll() async {
    if (state.syncStatus.isInProgress) return;
    emit(state.copyWith(syncStatus: FormzSubmissionStatus.inProgress));
    try {
      await _returnItemRepository.sync();
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
    return super.close();
  }
}
