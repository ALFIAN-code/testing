import 'package:flutter/material.dart';

class AfterBuildWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<BuildContext> onAfterBuild;

  const AfterBuildWidget({
    super.key,
    required this.child,
    required this.onAfterBuild,
  });

  @override
  State<AfterBuildWidget> createState() => _AfterBuildWidgetState();
}

class _AfterBuildWidgetState extends State<AfterBuildWidget> {
  bool _isCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isCalled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onAfterBuild(context);
      });
      _isCalled = true;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
