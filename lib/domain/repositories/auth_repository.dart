import '../../data/models/page_access/page_access_model.dart';
import '../../data/models/user_info/user_info_model.dart';

abstract class AuthRepository {
  Future<String> login();
  Future<void> getToken(String code);
  Future<String> logout();
  Future<UserInfoModel> getUserInfo();

  Future<PageAccessModel> getPageAccess();

}
