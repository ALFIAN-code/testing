class GoodsTestingEntity {
  final String name;
  final String merk;
  final String barcode;
  final String category;
  final DateTime checkDate;
  final List<String> checkingType;

  GoodsTestingEntity({
    required this.name,
    required this.merk,
    required this.barcode,
    required this.category,
    required this.checkDate,
    required this.checkingType,
  });
}
