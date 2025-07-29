import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/app_util.dart';
import '../../../../core/utils/formz.dart';
import '../../../../core/utils/validations/default_validator.dart';
import '../../../../data/models/item/item_model.dart';
import '../../../../data/request/item/create_item_image_request.dart';
import '../../../../data/request/item/create_item_request.dart';
import '../../../../data/request/item_test/create_item_test_inspection_image_request.dart';
import '../../../../domain/repositories/file_repository.dart';
import '../../../../domain/repositories/item_repository.dart';

part 'update_item_state.dart';

class UpdateItemBloc extends Cubit<UpdateItemState> {
  UpdateItemBloc(this._id, this._itemRepository, this._fileRepository) : super(const UpdateItemState());

  final String _id;
  final ItemRepository _itemRepository;
  final FileRepository _fileRepository;

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final ItemModel item = await _itemRepository.getDetailById(_id);
      emit(state.copyWith(
        itemModel: item,
        description: DefaultValidator.dirty(item.description ?? ''),
        brand: DefaultValidator.dirty(item.brand ?? ''),
        typeOrModel: DefaultValidator.dirty(item.model ?? ''),
        serialNumber: DefaultValidator.dirty(item.serialNumber ?? ''),
        technicalSpecification: DefaultValidator.dirty(item.specification ?? ''),
        status: FormzSubmissionStatus.success,
        imagePaths: item.itemImages.map((e) => e.imagePath).toList()
      ),);
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ),);
    }
  }

  void updateSelectedImage(List<String> imagePaths) {
    emit(state.copyWith(imagePaths: imagePaths));
  }

  void descriptionChanged(String value) => emit(state.withDescription(value));
  void brandChanged(String value) => emit(state.withBrand(value));
  void typeOrModelChanged(String value) => emit(state.withTypeOrModel(value));
  void serialNumberChanged(String value) => emit(state.withSerialNumber(value));
  void technicalSpecChanged(String value) => emit(state.withTechnicalSpec(value));

  Future<void> submit() async {
    emit(state.copyWith(formStatus: FormzSubmissionStatus.inProgress));
    try {
      final ItemModel? itemModel = state.itemModel;
      if (itemModel == null) throw Exception('Item tidak ditemukan');

      final List<String> existingImage = state.imagePaths.where((String element) => AppUtil.isNetworkImage(element)).toList();
      final List<String> updatedImagePaths = state.imagePaths.where((String element) => !AppUtil.isNetworkImage(element)).toList();

      final List<String> uploadImages = await _fileRepository.uploadMultipleFile('item', updatedImagePaths);

      final CreateItemRequest updatedItem = CreateItemRequest(
          itemCodeId: itemModel.itemCode?.id ?? '',
          description: state.description.value,
          brand: state.brand.value,
        model: state.typeOrModel.value,
        serialNumber: state.serialNumber.value,
        specification: state.technicalSpecification.value,
        barcode: itemModel.barcode,
        poReference: itemModel.poReference,
        purchasedDate: itemModel.purchasedDate,
        quantity: itemModel.quantity,
        itemImages: [...existingImage, ...uploadImages].map((String imagePath) => CreateItemImageRequest(imagePath: imagePath)).toList()
      );

      await _itemRepository.update(_id, updatedItem);

      emit(state.copyWith(
        formStatus: FormzSubmissionStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        formStatus: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
