import '../../domain/repositories/auth_repository.dart';
import '../models/page_access/page_access_model.dart';
import '../models/user_info/user_info_model.dart';
import '../providers/remote/implementations/remote_auth_provider.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthProvider _remoteAuthProvider;
  
  AuthRepositoryImpl({required RemoteAuthProvider remoteAuthProvider})
    : _remoteAuthProvider = remoteAuthProvider;

  @override
  Future<String> login() async => _remoteAuthProvider.generateCode();

  @override
  Future<void> getToken(String code) async =>
      _remoteAuthProvider.getToken(code);
      
  @override
  Future<String> logout() async => _remoteAuthProvider.logout();

  @override
  Future<PageAccessModel> getPageAccess() => _remoteAuthProvider.getPageAccess();

  @override
  Future<UserInfoModel> getUserInfo() => _remoteAuthProvider.getUserInfo();
}
