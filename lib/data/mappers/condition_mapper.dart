import '../../domain/entities/condition_entity.dart';
import '../models/condition/condition_model.dart';
import '../models/condition/condition_paginated_model.dart';
import 'condition_category_mapper.dart';

extension ConditionEntityMapper on ConditionEntity {
  ConditionPaginatedModel toPaginatedModel({int index = 0}) => ConditionPaginatedModel(
    index: index,
    id: id,
    name: name,
    code: code,
    conditionCategoryId: conditionCategoryId,
  );

  ConditionModel toModel() => ConditionModel(
    id: id,
    name: name,
    code: code,
    conditionCategoryId: conditionCategoryId,
    conditionCategory: conditionCategory?.toModel(),
  );
}


extension ConditionPaginatedModelMapper on ConditionPaginatedModel {
  ConditionEntity toEntity() => ConditionEntity(
      id: id,
      name: name,
      code: code,
      conditionCategoryId: conditionCategoryId,
      conditionCategory: null, // Data tidak tersedia di model paginated
    );
}