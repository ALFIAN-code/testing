abstract class IRemoteFCMTokenProvider {
  Future<void> register(String token, String appVersion);
  Future<void> unregister(String token);
}