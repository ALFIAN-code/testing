import '../../../models/page_access/page_access_model.dart';
import '../../../models/user_info/user_info_model.dart';

abstract class IAuthProvider {
  Future<String> generateCode();
  
  Future<void> getToken(String code);
  
  Future<String> logout();

  Future<UserInfoModel> getUserInfo();

  Future<PageAccessModel> getPageAccess();
}
