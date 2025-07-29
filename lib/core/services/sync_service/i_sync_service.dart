abstract class ISyncService {
  void start();
  void register<T>(Future<T> Function() task, Duration interval);
  void clear();
  void stop();
}