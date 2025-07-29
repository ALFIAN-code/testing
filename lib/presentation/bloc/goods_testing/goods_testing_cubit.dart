import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/app/app_status.dart';
import '../../../data/models/item/item_test_model.dart';
import '../../../domain/entities/goods_testing_entity.dart';
import '../../../domain/repositories/item_test_repository.dart';

part 'goods_testing_state.dart';

class GoodsTestingCubit extends Cubit<GoodsTestingState> {

  final ItemTestRepository itemTestRepository;

  GoodsTestingCubit(this.itemTestRepository) : super(const GoodsTestingState());

  Future<void> getLastInspection(String code) async {
    try {
      if (code.isEmpty) {
        throw Exception('Kode anda kosong');
      }

      emit(state.copyWith(status: AppStatus.loading));
      final ItemTestModel result = await itemTestRepository.getDetailBarcode(code);

      emit(state.copyWith(
          itemTestModel: result,
        status: AppStatus.success
      ));

    } catch (e) {
      emit(
        GoodsTestingState(
          errorMessage: e.toString(),
          status: AppStatus.failure,
        ),
      );
      rethrow;
    }
  }

  void resetScannedItem() {
    emit(state.copyWith(status: AppStatus.initial));
  }
}
