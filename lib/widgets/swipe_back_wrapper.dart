import 'dart:async';

import 'package:flutter/material.dart';

class SwipeBackWrapper extends StatefulWidget {
  const SwipeBackWrapper({
    super.key,
    required this.child,
    required this.onBack,
  });

  final Widget child;
  final Future<void> Function() onBack;

  @override
  State<SwipeBackWrapper> createState() => _SwipeBackWrapperState();
}

class _SwipeBackWrapperState extends State<SwipeBackWrapper> {
  static const double _swipeTriggerDistance = 100.0;

  double _dragDistance = 0.0;
  bool _didTriggerBack = false;

  void _handleDragStart(DragStartDetails details) {
    _dragDistance = 0.0;
    _didTriggerBack = false;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_didTriggerBack) {
      return;
    }

    _dragDistance += details.delta.dx;

    if (_dragDistance >= _swipeTriggerDistance) {
      _didTriggerBack = true;
      unawaited(widget.onBack());
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _dragDistance = 0.0;
    _didTriggerBack = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _handleDragStart,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
          ),
        ),
      ],
    );
  }
}
