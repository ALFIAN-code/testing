import 'dart:async';
import 'package:flutter/material.dart';

class RepetitiveCaller extends StatefulWidget {
  final Duration interval;
  final Future<void> Function() onTick;
  final Widget child;

  const RepetitiveCaller({
    super.key,
    required this.interval,
    required this.onTick,
    required this.child,
  });

  @override
  State<RepetitiveCaller> createState() => _RepetitiveCallerState();
}

class _RepetitiveCallerState extends State<RepetitiveCaller> {
  Timer? _timer;
  bool _isDisposed = false;
  bool _isTicking = false;

  @override
  void initState() {
    super.initState();
    _startCalling();
  }

  void _startCalling() {
    _timer = Timer.periodic(widget.interval, (timer) async {
      if (_isDisposed || _isTicking) return;

      _isTicking = true;
      try {
        await widget.onTick();
      } catch (e, st) {
        debugPrint('onTick error: $e\n$st');
      } finally {
        _isTicking = false;
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

