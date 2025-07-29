import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/app/app_status.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/item/item_model.dart';
import '../../../domain/repositories/inspection_repository.dart';
import '../../../domain/repositories/item_repository.dart';

part 'item_inspection_state.dart';

class ItemInspectionBloc extends Cubit<ItemInspectionState> {

  final ItemRepository itemRepository;
  final InspectionRepository inspectionRepository;

  ItemInspectionBloc(this.itemRepository, this.inspectionRepository) : super(const ItemInspectionState()) {
    _startSyncLoop();
  }

  Timer? _syncTimer;

  void _startSyncLoop() {
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (state.syncStatus == FormzSubmissionStatus.inProgress) return;
      await inspectionRepository.sync();
      final int total = await inspectionRepository.getNotSyncYet();
      emit(state.copyWith(totalNotSynchronized: total));
    });
  }

  Future<void> getItemData(String barcode) async {

    try {
      if (barcode.isEmpty) throw Exception('Barcode kosong');
      emit(state.copyWith(
          setItemModelToNull: true,
          scannedBarcode: barcode,
          status: FormzSubmissionStatus.inProgress));

      final ItemModel itemModel = await itemRepository.getDetailBarcode(barcode);

      await inspectionRepository.logInspection(itemModel.id);

      final int total = await inspectionRepository.getNotSyncYet();

      emit(state.copyWith(
        totalNotSynchronized: total,
        itemModel: itemModel, status: FormzSubmissionStatus.success,
      ),);
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(),
          itemModel: null,
          status: FormzSubmissionStatus.failure),);
      rethrow;
    }
  }

  void syncAll() async {
    emit(state.copyWith(syncStatus: FormzSubmissionStatus.inProgress));
    try {
      await inspectionRepository.sync();
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