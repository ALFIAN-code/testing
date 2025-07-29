class SchedulerModel {
  final Future<void> Function() task;
  final Duration interval;
  DateTime lastRun;

  SchedulerModel({
    required this.task,
    required this.interval,
  })  : lastRun = DateTime.fromMillisecondsSinceEpoch(0);
}