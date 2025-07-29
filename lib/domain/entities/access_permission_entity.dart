class AccessPermissionEntity {
  final String moduleName;
  final bool canView;
  final bool canInsert;
  final bool canUpdate;
  final bool canUpsert;
  final bool canDelete;
  final bool canHistory;

  AccessPermissionEntity({
    required this.moduleName,
    this.canView = false,
    this.canInsert = false,
    this.canUpdate = false,
    this.canUpsert = false,
    this.canDelete = false,
    this.canHistory = false,
  });

  factory AccessPermissionEntity.fromMap(Map<String, dynamic> map) => AccessPermissionEntity(
    moduleName: map['module'] as String? ?? '',
    canView: map['view'] as bool? ?? false,
    canInsert: map['insert'] as bool? ?? false,
    canUpdate: map['update'] as bool? ?? false,
    canUpsert: map['upsert'] as bool? ?? false,
    canDelete: map['delete'] as bool? ?? false,
    canHistory: map['history'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
      'module': moduleName,
      'view': canView,
      'insert': canInsert,
      'update': canUpdate,
      'upsert': canUpsert,
      'delete': canDelete,
      'history': canHistory,
    };
}
