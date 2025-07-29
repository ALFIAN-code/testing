class PageAccessModel {
  final Map<String, List<String>> permissions;

  PageAccessModel({required this.permissions});

  factory PageAccessModel.fromJson(Map<String, dynamic> json) {
    final Map<String, List<String>> parsed = {};

    json.forEach((String key, dynamic value) {
      if (value is List) {
        parsed[key] = value.map((e) => e.toString()).toList();
      }
    });

    return PageAccessModel(permissions: parsed);
  }

  Map<String, dynamic> toJson() => permissions;

  bool hasPageAccess(String entity, String action) =>
      permissions[entity]?.contains(action) ?? false;
}
