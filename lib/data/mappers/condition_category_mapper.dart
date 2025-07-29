import '../../domain/entities/condition_category_entity.dart';
import '../models/condition_category/condition_category_model.dart';
import '../models/condition_category/condition_category_paginated_model.dart';

extension ConditionCategoryPaginatedModelMapper on ConditionCategoryPaginatedModel {
  ConditionCategoryEntity toEntity() => ConditionCategoryEntity(
    id: id,
    name: name,
    code: code,
  );

  static ConditionCategoryPaginatedModel fromEntity(ConditionCategoryEntity entity, {int index = 0}) =>
      ConditionCategoryPaginatedModel(
        index: index,
        id: entity.id,
        name: entity.name,
        code: entity.code,
      );
}

extension ConditionCategoryEntityMapper on ConditionCategoryEntity {
  ConditionCategoryModel toModel() => ConditionCategoryModel(
      id: id,
      name: name,
      code: code
  );
}

extension ConditionCategoryPaginatedEntityMapper on ConditionCategoryEntity {
  ConditionCategoryPaginatedModel toPaginatedModel({int index = 0}) => ConditionCategoryPaginatedModel(
    index: index,
    id: id,
    name: name,
    code: code,
  );
}