class ItemPreparationException implements Exception {
  final String message;

  ItemPreparationException(this.message);
  @override
  String toString() => message;
}