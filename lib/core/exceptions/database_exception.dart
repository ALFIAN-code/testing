abstract class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);

  @override
  String toString() => message;
}

final class DataNotFoundDatabaseException extends DatabaseException {
  DataNotFoundDatabaseException(super.message);
}