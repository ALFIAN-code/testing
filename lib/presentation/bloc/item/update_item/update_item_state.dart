part of 'update_item_bloc.dart';

final class UpdateItemState extends Equatable {
  const UpdateItemState() : this._();

  const UpdateItemState._({
    this.description = const DefaultValidator.pure(),
    this.brand = const DefaultValidator.pure(),
    this.typeOrModel = const DefaultValidator.pure(),
    this.serialNumber = const DefaultValidator.pure(),
    this.technicalSpecification = const DefaultValidator.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.formStatus = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.itemModel,
    this.imagePaths = const [],
  });

  final DefaultValidator description;
  final DefaultValidator brand;
  final DefaultValidator typeOrModel;
  final DefaultValidator serialNumber;
  final DefaultValidator technicalSpecification;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus formStatus;
  final String? errorMessage;
  final ItemModel? itemModel;
  final List<String> imagePaths;

  bool get isValid => Formz.validate([
    description,
  ]);

  UpdateItemState withDescription(String value) => copyWith(
    description: DefaultValidator.dirty(value),
  );

  UpdateItemState withBrand(String value) => copyWith(
    brand: DefaultValidator.dirty(value),
  );

  UpdateItemState withTypeOrModel(String value) => copyWith(
    typeOrModel: DefaultValidator.dirty(value),
  );

  UpdateItemState withSerialNumber(String value) => copyWith(
    serialNumber: DefaultValidator.dirty(value),
  );

  UpdateItemState withTechnicalSpec(String value) => copyWith(
    technicalSpecification: DefaultValidator.dirty(value),
  );

  UpdateItemState copyWith({
    DefaultValidator? description,
    DefaultValidator? brand,
    DefaultValidator? typeOrModel,
    DefaultValidator? serialNumber,
    DefaultValidator? technicalSpecification,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? formStatus,
    String? errorMessage,
    ItemModel? itemModel,
    List<String>? imagePaths,
  }) =>
      UpdateItemState._(
        description: description ?? this.description,
        brand: brand ?? this.brand,
        typeOrModel: typeOrModel ?? this.typeOrModel,
        serialNumber: serialNumber ?? this.serialNumber,
        technicalSpecification:
        technicalSpecification ?? this.technicalSpecification,
        status: status ?? this.status,
        formStatus: formStatus ?? this.formStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        itemModel: itemModel ?? this.itemModel,
        imagePaths: imagePaths ?? this.imagePaths,
      );

  @override
  List<Object?> get props => <Object?>[
    description,
    brand,
    typeOrModel,
    serialNumber,
    technicalSpecification,
    status,
    formStatus,
    errorMessage,
    itemModel,
    imagePaths,
  ];
}
