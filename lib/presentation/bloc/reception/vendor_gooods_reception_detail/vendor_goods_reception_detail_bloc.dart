import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/app/app_status.dart';
import '../../../../data/models/item_vendor_reception/item_vendor_reception_model.dart';
import '../../../../domain/repositories/item_vendor_reception_repository.dart';

part 'vendor_goods_reception_detail_state.dart';

class VendorGoodsReceptionDetailBloc extends Cubit<VendorGoodsReceptionDetailState> {
  final ItemVendorReceptionRepository itemVendorReceptionRepository;

  VendorGoodsReceptionDetailBloc(this.itemVendorReceptionRepository)
      : super(const VendorGoodsReceptionDetailState());

  Future<void> initial(String id) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      final ItemVendorReceptionModel result = await itemVendorReceptionRepository.getDetail(id);

      emit(state.copyWith(
        status: AppStatus.success,
        itemVendorReception: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.failure,
        errorMessage: e.toString(),
      ),);
      rethrow;
    }
  }
}
