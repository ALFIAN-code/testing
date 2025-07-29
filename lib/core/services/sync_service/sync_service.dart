import 'dart:async';

import '../../../data/models/scheduler_model.dart';
import 'i_sync_service.dart';

class SyncService implements ISyncService {

    final List<SchedulerModel> _schedulers = <SchedulerModel>[];
    Timer? _timer;

  @override
  void register<T>(Future<T> Function() task, Duration interval) {
    _schedulers.add(SchedulerModel(task: () => task(), interval: interval));
  }

  @override
  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final DateTime now = DateTime.now();

      for (SchedulerModel scheduled in _schedulers) {
        final bool shouldRun =
            now.difference(scheduled.lastRun) >= scheduled.interval;

        if (shouldRun) {
          try {
            scheduled.lastRun = now;
            await scheduled.task();
          } catch (e, stack) {
            print('[SyncService] Task error: $e\n$stack');
          }
        }
      }
    });
  }

  @override
  void clear() {
    _schedulers.clear();
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}