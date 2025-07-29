import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/constants/preference_constants.dart';
import '../../core/services/secure_storage_service/secure_storage_service.dart';
import '../../domain/repositories/fcm_token_repository.dart';
import '../providers/remote/interfaces/i_remote_fcm_token_provider.dart';

class FCMTokenRepositoryImpl implements FCMTokenRepository {

  final SecureStorageService _secureStorageService;
  final IRemoteFCMTokenProvider _remoteFCMTokenProvider;

  FCMTokenRepositoryImpl(this._secureStorageService, this._remoteFCMTokenProvider);

  @override
  Future<void> register() async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        await _remoteFCMTokenProvider.register(token, packageInfo.version);
        await _secureStorageService.set(PreferenceConstants.fcmToken, token);
      }
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> unregister() async {
    try {
      final String? token = await _secureStorageService.get(PreferenceConstants.fcmToken);
      if (token != null) {
        await _remoteFCMTokenProvider.unregister(token);
        await _secureStorageService.delete(PreferenceConstants.fcmToken);
      }
    } catch(e) {
      rethrow;
    }
  }

}