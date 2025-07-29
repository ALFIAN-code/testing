import '../../domain/entities/access_permission_entity.dart';

class AccessPermissionModel {
  final String module;
  final bool view;
  final bool insert;
  final bool update;
  final bool upsert;
  final bool delete;
  final bool history;

  AccessPermissionModel({
    required this.module,
    this.view = false,
    this.insert = false,
    this.update = false,
    this.upsert = false,
    this.delete = false,
    this.history = false,
  });

  factory AccessPermissionModel.fromJson(Map<String, dynamic> json) =>
      AccessPermissionModel(
        module: json['module'] as String? ?? '',
        view: json['view'] == true || json['view'] == 1,
        insert: json['insert'] == true || json['insert'] == 1,
        update: json['update'] == true || json['update'] == 1,
        upsert: json['upsert'] == true || json['upsert'] == 1,
        delete: json['delete'] == true || json['delete'] == 1,
        history: json['history'] == true || json['history'] == 1,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'module': module,
    'view': view,
    'insert': insert,
    'update': update,
    'upsert': upsert,
    'delete': delete,
    'history': history,
  };

  AccessPermissionEntity toEntity() => AccessPermissionEntity(
    moduleName: module,
    canView: view,
    canInsert: insert,
    canUpdate: update,
    canUpsert: upsert,
    canDelete: delete,
    canHistory: history,
  );

  factory AccessPermissionModel.fromEntity(AccessPermissionEntity entity) =>
      AccessPermissionModel(
        module: entity.moduleName,
        view: entity.canView,
        insert: entity.canInsert,
        update: entity.canUpdate,
        upsert: entity.canUpsert,
        delete: entity.canDelete,
        history: entity.canHistory,
      );
}
