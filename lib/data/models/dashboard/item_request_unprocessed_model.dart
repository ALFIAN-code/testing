class ItemRequestUnprocessedModel {
  final int total;
  final int equipment;
  final int stock;

  ItemRequestUnprocessedModel({
    required this.total,
    required this.equipment,
    required this.stock,
  });

  factory ItemRequestUnprocessedModel.fromJson(Map<String, dynamic> json) => ItemRequestUnprocessedModel(
      total: json['total'] as int? ?? 0,
      equipment: json['equipment'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
    );

  Map<String, dynamic> toJson() => {
      'total': total,
      'equipment': equipment,
      'stock': stock,
    };
}
