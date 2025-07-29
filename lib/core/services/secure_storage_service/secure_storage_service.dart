import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final String _tokenKey = 'auth_token';
  final String _idToken = 'id_token';
  final String _roleActive = 'role_active';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> saveIdToken(String token) async {
    await _storage.write(key: _idToken, value: token);
  }

  Future<void> saveRoleActive(String role) async {
    await _storage.write(key: 'role_active', value: role);
  }

  Future<String?> getToken() async => _storage.read(key: _tokenKey);

  Future<String?> getIdToken() async => _storage.read(key: _idToken);

  Future<String?> getRoleActive() async => _storage.read(key: _roleActive);

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> deleteIdToken() async {
    await _storage.delete(key: _idToken);
  }

  Future<void> deleteRoleActive() async {
    await _storage.delete(key: _roleActive);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> set(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> get(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

}
